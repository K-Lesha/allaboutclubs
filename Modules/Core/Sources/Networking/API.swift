import Alamofire
import Fetch
import Foundation
import Models
import Utilities

public enum API {
    public static func setup() {
        APIClient.shared.setup(with: Fetch.Config(
            baseURL: Config.API.baseURL,
            timeout: Config.API.timeout,
            eventMonitors: [APILogger(verbose: Config.API.verboseLogging)],
            interceptor: AuthHandler(),
            jsonDecoder: Decoders.standardJSON,
            cache: MemoryCache(defaultExpiration: .seconds(Config.Cache.defaultExpiration)),
            shouldStub: Config.API.stubRequests)
        )
        
    }

    public enum Auth {
        public static func login(username: String, password: String) -> Resource<Credentials> {
            return Resource(
                method: .post,
                path: "/api/v1/auth/login",
                body: .encodable([
                    "grantType": "password",
                    "scope": "user",
                    "username": username,
                    "password": password
                ])
            )
        }

        public static func tokenRefresh(_ refreshToken: String) -> Resource<Credentials> {
            return Resource(
                method: .post,
                path: "/api/v1/auth/refresh",
                body: .encodable([
                    "grantType": "refreshToken",
                    "scope": "user",
                    "refreshToken": refreshToken
                ])
            )
        }
    }
    
    public enum Clubs {
        public static func list() -> Resource<[Club]> {
            return Resource(
                method: .get,
                path: "/hiring/clubs.json"
            )
        }
    }
}
