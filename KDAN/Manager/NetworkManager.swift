//
//  NetworkSession.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import UIKit

enum NetworkError: Error, LocalizedError {
    case invalidURL
    case noResponse
    case httpError(code: Int)
    case noData
    case decodingError(Error)
    case noInternetConnection
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "無效的網址"
        case .noResponse:
            return "沒有收到伺服器回應"
        case .httpError(let code):
            return "伺服器錯誤，代碼：\(code)"
        case .noData:
            return "沒有收到任何資料"
        case .decodingError:
            return "資料解析失敗"
        case .noInternetConnection:
            return "目前沒有網路連線，請檢查您的網路狀態"
        case .unknown(let error):
            return "未知錯誤：\(error.localizedDescription)"
        }
    }
}

final class NetworkManager {
    static let shared = NetworkManager()
    private init() {}

    private var etagCache: [String: String] = [:]
    private var responseCache: [String: Data] = [:]

    func request<T: Decodable>(urlString: String,
                                method: String = "GET",
                                headers: [String: String]? = nil,
                                completion: @escaping (Result<T, Error>) -> Void) {
        
        guard let url = URL(string: urlString) else {
            DispatchQueue.main.async {
                completion(.failure(NetworkError.invalidURL))
            }
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = method
        
        headers?.forEach { key, value in
            if request.value(forHTTPHeaderField: key) == nil {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        request.setValue("application/vnd.github+json", forHTTPHeaderField: "Accept")
        //Token機制，次數5000次
        request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
        
        if let etag = etagCache[urlString] {
            request.setValue(etag, forHTTPHeaderField: "If-None-Match")
        }
        request.cachePolicy = .reloadIgnoringLocalCacheData

        URLSession.shared.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else { return }

            if let error = error {
                if let urlError = error as? URLError, urlError.code == .notConnectedToInternet {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noInternetConnection))
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.unknown(error)))
                    }
                }
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.noResponse))
                }
                return
            }

            switch httpResponse.statusCode {
            case 200:
                guard let data = data else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noData))
                    }
                    return
                }

                if let etag = httpResponse.allHeaderFields["Etag"] as? String {
                    self.etagCache[urlString] = etag
                    self.responseCache[urlString] = data
                }

                do {
                    let decoded = try JSONDecoder().decode(T.self, from: data)
                    DispatchQueue.main.async {
                        completion(.success(decoded))
                    }
                } catch {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.decodingError(error)))
                    }
                }

            case 304:
                if let cachedData = self.responseCache[urlString] {
                    do {
                        let decoded = try JSONDecoder().decode(T.self, from: cachedData)
                        DispatchQueue.main.async {
                            completion(.success(decoded))
                        }
                    } catch {
                        DispatchQueue.main.async {
                            completion(.failure(NetworkError.decodingError(error)))
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        completion(.failure(NetworkError.noData))
                    }
                }

            default:
                DispatchQueue.main.async {
                    completion(.failure(NetworkError.httpError(code: httpResponse.statusCode)))
                }
            }

        }.resume()
    }
}
