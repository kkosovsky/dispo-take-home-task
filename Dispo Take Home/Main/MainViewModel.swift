import Combine
import UIKit

typealias MainViewModelInput = (
    cellTapped: AnyPublisher<SearchResult, Never>,
    searchText: AnyPublisher<String, Never>,
    viewWillAppear: AnyPublisher<Void, Never>
)

typealias MainViewModelOutput = (
    loadResults: AnyPublisher<[SearchResult], Never>,
    pushDetailView: AnyPublisher<SearchResult, Never>
)

func liveMainViewModel(input: MainViewModelInput) -> MainViewModelOutput {
    TenorAPIClient.live |> (input |> mainViewModel)
}

func mainViewModel(input: MainViewModelInput) -> (TenorApiClientType) -> MainViewModelOutput {
    { apiClient in
        let featuredGifs = Empty<[SearchResult], Never>()
        let searchResults = input.searchText
            .map {
                apiClient.searchGIFs($0)
            }
            .switchToLatest()

        let loadResults = searchResults
            .eraseToAnyPublisher()

        let pushDetailView = Empty<SearchResult, Never>()
            .eraseToAnyPublisher()

        return (
            loadResults: loadResults,
            pushDetailView: pushDetailView
        )
    }
}
