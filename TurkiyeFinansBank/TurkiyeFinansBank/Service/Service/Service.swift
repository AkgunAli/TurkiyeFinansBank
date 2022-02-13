//
//  Service.swift
//  TurkiyeFinansBank
//
//  Created by Ali Akgün on 5.02.2022.
//

import Foundation
import Alamofire
import AlamofireObjectMapper
import ObjectMapper
import UIKit

// MARK: Content Types
enum ApiContentTypeEnum: String {
    case applicationJson = "text/javascript"
}

// MARK: Timeout
class API: SessionDelegate {
    static let shared = API()
    private var session: Session?
    private let timeoutIntervalForRequest: Double = 300

    private init() {
        super.init()
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = timeoutIntervalForRequest
        
        let trustManager = ServerTrustManager(allHostsMustBeEvaluated: false,evaluators: [
                                                Constant.baseUrl: DisabledEvaluator()])

        self.session = Session(configuration: configuration,
                               delegate: self,
                               startRequestsImmediately: true,
                               serverTrustManager: trustManager)
    }
    
    func request<S: Mappable, F: ErrorMessage>(methotType: HTTPMethod,
                                          params: [String: Any]?,
                                          baseURL: String = Constant.baseUrl,
                                          urlPath: String,
                                          contentType: String = ApiContentTypeEnum.applicationJson.rawValue,
                                          headerParams: ([String: String])? = nil,
                                          succeed: @escaping (S) -> Void,
                                          failed: @escaping (F) -> Void) {
        guard let session = session else { return }
        if networkIsReachable() {
            var url = baseURL + urlPath
            var bodyParams: [String: Any]?
            if let params = params {
                if methotType == .get {
                    url.append(URLQueryBuilder(params: params).build())
                } else {
                    bodyParams = params
                }
            }
            print("url " , url)
            let headerParams = prepareHeaderForSession(urlPath,
                                                       methotType,
                                                       bodyParams,
                                                       headerParams,
                                                       contentType)
            printRequest(url: url, methodType: methotType, body: bodyParams, headerParams: headerParams)

            let networkRequest = session.request(url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!,
                                                 method: methotType,
                                                 parameters: bodyParams,
                                                 encoding: JSONEncoding.default,
                                                 headers: HTTPHeaders(headerParams))
                .validate(contentType: [contentType])
            validateResponse(dataRequest: networkRequest) { [weak self] succeeded in
                guard succeeded else {
                    return
                }
                self?.handleJsonResponse(dataRequest: networkRequest,
                                         succeed: succeed,
                                         failed: failed)
            }
        } else {
            print( "error" )
        }
    }
    
    private func validateResponse(dataRequest: DataRequest,
                                  completionHandler: @escaping (Bool) -> Void) {

        dataRequest.responseString(encoding: String.Encoding.utf8) { response in
            completionHandler(true)
        }
    }

    private func handleJsonResponse<S: Mappable, F: Mappable>(dataRequest: DataRequest,
                                                              succeed: @escaping (S) -> Void,
                                                              failed: @escaping (F) -> Void) {
        let start = Date().timeIntervalSince1970
        dataRequest.responseJSON { [weak self] response in
            guard let self = self else { return }
            self.printResponse(response: response.value,
                               statusCode: response.response?.statusCode,
                               url: response.request?.description,
                               time: Date().timeIntervalSince1970 - start)
                switch response.result {
                case .success:
                    switch self.statusType((response.response?.statusCode)!) {
                    case .success:
                        do {
                            self.handleSuccessfulResponseObject(dataRequest: dataRequest, succeed: succeed)
                        }
                    case .error:
                            self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                    default :
                        break
                    }
                case .failure:
                        self.handleFailureResponseObject(dataRequest: dataRequest, failed: failed)
                }
        }
    }
    
    private func handleSuccessfulResponseObject<S: Mappable>(dataRequest: DataRequest,
                                                            succeed: @escaping (S) -> Void) {
        dataRequest.responseObject { (response: DataResponse<S, AFError>) in
            if let responseObject = response.value {
                succeed(responseObject)
            } else {
                let emptyResponse = S(JSON: [:])
                if let emptyResponse = emptyResponse {
                    succeed(emptyResponse)
                }
            }
        }
    }
    
    private func handleFailureResponseObject<F: Mappable>(dataRequest: DataRequest,
                                                          failed: @escaping (F) -> Void) {
        dataRequest.responseObject { (response: DataResponse<F, AFError>) in
            if let responseObject = response.value {
                if let errorMessage = responseObject as? ErrorMessage {
                    errorMessage.httpStatus = response.response?.statusCode
                }
                failed(responseObject)
            }
        }
    }
    private func statusType(_ statusCode: Int) -> StatusType {
        switch statusCode {
        case 200 ..< 300, 428:
            return .success
        case 300 ..< 400:
            return .warning
        case 400 ..< 600:
            return .error
        default:
            return .unknown
        }
    }

    public func networkIsReachable () -> Bool {
        let networkManager = NetworkReachabilityManager()
        let result = networkManager?.isReachable
        return result ?? false
    }

    public func hasCellularNetwork() -> Bool {
        let networkManager = NetworkReachabilityManager()
        return ((networkManager?.isReachableOnCellular) != nil)
    }

    func printRequest(url: String?,
                      methodType: HTTPMethod?,
                      body: [String: Any]?,
                      headerParams: [String: String]) {
        #if DEBUG
        let header = headerParams.reduce("\n   ") { $0 + $1.key + ":" + $1.value + "\n      " }
        print("""
            --------------------------------------------------
            Request Url: \(url ?? "")
            Request Type: \(String(describing: methodType))
            Request Parameters: \(String(describing: body))
            Request Headers: \(header)
            """)
        #endif
    }

    func printResponse(response: Any?,
                       statusCode: Int?,
                       url: String?,
                       time: TimeInterval) {
        #if DEBUG

        print("--------------------------------------------------")

        var options: JSONSerialization.WritingOptions
        if #available(iOS 13.0, *) {
            options = [.prettyPrinted, .withoutEscapingSlashes]
        } else {
            options = [.prettyPrinted]
        }
        if let prettyJson = (response as? [String: Any?])?.toJsonStr(option: options) {
            print(prettyJson)
        } else {
            print(String(describing: response))
        }

        print("""
            --------------------------------------------------
            Response Url: \(url ?? "")
            Response StatusCode: \(String(describing: statusCode))
            Response :  \(response ?? "")
            Response Time: \(time)
            """)
        #endif
    }

}


private func prepareHeaderForSession(_ requestUrl: String,
                                     _ methotType: HTTPMethod,
                                     _ bodyParams: ([String: Any])?,
                                     _ extraHeaderParams: ([String: String])?,
                                     _ contentType: String) -> [String: String] {

    var allHeaderFields: [String: String] = [:]
    allHeaderFields["Content-Type"] = contentType
    if let extraHeaderParams = extraHeaderParams, !extraHeaderParams.isEmpty {
        allHeaderFields.merge(extraHeaderParams) { _, new in new }
    }

    return allHeaderFields
}


struct URLQueryBuilder {
    let params: [String: Any]

    func build() -> String {
        guard !params.keys.isEmpty else { return "" }

        var query = ""
        query = params
            .compactMap { item in
                if let doubleValue = item.value as? Double {
                    return "\(item.key)=\(doubleValue.string(usesGroupingSeparator: false))"
                } else {
                    return "\(item.key)=\(item.value)"
                }
            }
            .joined(separator: "&")

        return "?\(query)"
    }

}
enum StatusType: String {
    case success
    case warning
    case error
    case inform
    case confirm
    case unknown
}



@objc
class ErrorMessage: NSObject, Mappable {
    @objc var responseType: Int = 0
    @objc var message: String = ""
    @objc var title: String = ""
    var httpStatus: Int?
    var code: Int? = 0

    required init?(map: Map) {
        // Intentionally unimplemented
    }

    override init() {
        // Intentionally unimplemented
    }

    convenience init(message: String,
                     title: String,
                     responseType: Int = 0,
                     httpStatus: Int? = nil,
                     code: Int? = 0) {
        self.init()
        self.message = message
        self.title = title
        self.responseType = responseType
        self.httpStatus = httpStatus
        self.code = code
    }

    func mapping(map: Map) {
        message <- map["message"]
        title <- map["Title"]
        code <- map["code"]
    }

}
