store BlockStore {
  state currentPage : String = "0"
  state perPage : String = "10"
  state blockError : String = ""
  state blocks : Maybe(BlocksResponse) = Maybe.nothing()

  fun setCurrentPage(currentPage : String) : Promise(Never, Void) {
    next { currentPage = currentPage }
  }

   fun setPerPage(perPage : String) : Promise(Never, Void) {
    next { perPage = perPage }
  }

   fun getBlocks : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/blockchain?page=" + currentPage + "&per_page=" + perPage + "&sort_field=time")
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with blocks")

      result =
        decode json as ApiResponseBlocks

      next { blocks = Maybe.just(result.blocks) }
    } catch {
      next { blockError = "Could not fetch blocks" }
    }
  } 
}
