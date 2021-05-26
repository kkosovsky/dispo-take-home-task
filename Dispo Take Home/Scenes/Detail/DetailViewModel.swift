import Combine

typealias DetailViewModelInput = AnyPublisher<SearchResult, Never>
typealias DetailViewModelOutput = AnyPublisher<GifInfo, Never>

func liveDetailViewModel(input: DetailViewModelInput) -> DetailViewModelOutput {
    TenorAPIClient.live |> (input |> detailViewModel)
}

func detailViewModel(input: DetailViewModelInput) -> (TenorApiClientType) -> DetailViewModelOutput {
    { apiClient in
        input.map {
            apiClient.gifInfo($0.id)
        }
        .switchToLatest()
        .eraseToAnyPublisher()
    }
}
