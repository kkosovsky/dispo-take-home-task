import Combine

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
        let featuredGifs = input.viewWillAppear
            .combineLatest(input.searchText)
            .filter({ _, query in
                query.isEmpty
            })
            .map { _ in Void() }
            .map(apiClient.featuredGIFs)
            .switchToLatest()

        let searchResults = input.searchText
            .filter { !$0.isEmpty }
            .map(apiClient.searchGIFs)
            .switchToLatest()

        let loadResults = searchResults
            .merge(with: featuredGifs)
            .eraseToAnyPublisher()

        return MainViewModelOutput(loadResults: loadResults, pushDetailView: input.cellTapped)
    }
}
