record SearchResponse {
  status : String,
  result : SearchResult
}

record SearchResult {
  found : Bool,
  category : String
}

component Search {
  state searchPerformed : Bool = false
  state searchTerm : String = ""
  state error : String = ""

  fun render : Html {
    <div class="form-inline">
      <div class="search-element">
        <button
          onClick={search}
          class="btn btn-primary-color"
          type="submit">

          <i class="fa fa-search"/>

        </button>

        <input
          onInput={onSearch}
          onKeyPress={(event : Html.Event) { UiHelper.submitOnEnter(event, search) }}
          type="search"
          class="form-control header-search"
          placeholder="Search by Address / Txn Id / Block / Hra"
          aria-label="Search"
          tabindex="1"/>
      </div>
    </div>
  }

  fun onSearch (event : Html.Event) {
    next { searchTerm = Dom.getValue(event.target) }
  }

  fun search (event : Html.Event) : Promise(Never, Void) {
    sequence {
      Debug.log("searching: ")
      Debug.log(searchPerformed)
      performSearch()
    }
  }

  fun performSearch : Promise(Never, Void) {
    if (!searchPerformed) {
      sequence {
        response =
          Http.get(Network.baseUrl() + "/api/v1/search/" + searchTerm)
          |> Http.send()

        json =
          Json.parse(response.body)
          |> Maybe.toResult("Json parsing error with blocks")

        result =
          decode json as SearchResponse

        if (result.result.category == "address") {
          navigateAway("/address/" + searchTerm)
        } else if (result.result.category == "domain") {
          navigateAway("/domain/" + searchTerm)
        } else if (result.result.category == "transaction") {
          navigateAway("/transactions/" + searchTerm)
        } else if (result.result.category == "block") {
          navigateAway("/blocks/" + searchTerm)
        } else {
          navigateAway("/no_search/" + searchTerm)
        }
      } catch {
        next
          {
            error = "Could not perform search",
            searchPerformed = false
          }
      }
    } else {
      Promise.never()
    }
  }

  fun navigateAway (url : String) : Promise(Never, Void) {
    sequence {
      next
        {
          searchPerformed = false,
          searchTerm = ""
        }

      Window.navigate(url)
    }
  }
}
