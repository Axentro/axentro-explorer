component WalletBalance {
  connect Application exposing { address }

  state walletInfo : Maybe(ApiAddressInfo) = Maybe.nothing()
  state error : String = ""

  fun componentDidMount : Promise(Never, Void) {
    getWalletInfo()
  }

  fun componentDidUpdate : Promise(Never, Void) {
    getWalletInfo()
  }

  fun render : Html {
    walletInfo
    |> Maybe.map(renderView)
    |> Maybe.withDefault(<div/>)
  }

  fun renderView (walletInfo : ApiAddressInfo) : Html {
    <div class="card text-left bg-gradient-primary text-white">
      <div class="card-body">
        <h5>"Wallet Balance"</h5>

        <h2 class="font-weight-bold text-black">
          <{ getAxeAmount(walletInfo.tokens) }>

          <span class="small">
            " AXNT"
          </span>
        </h2>

        <{ getWalletAddress(address, walletInfo.readable) }>
      </div>

      <div class="bg-white">
        <{ tokenTable(walletInfo.tokens) }>
      </div>
    </div>
  }

  fun getAxeAmount (tokens : Array(ApiAddressToken)) : String {
    tokens
    |> Array.find((token : ApiAddressToken) : Bool { token.name == "AXNT" })
    |> Maybe.map((token : ApiAddressToken) : String { token.amount })
    |> Maybe.withDefault("0")
  }

  fun getWalletAddress (address : String, readable : Array(String)) : Html {
    Array.first(readable)
    |> Maybe.map(
      (domain : String) : Html {
        <div class="tag tag-red">
          <{ domain }>
        </div>
      })
    |> Maybe.withDefault(
      <div class="small">
        <{ address }>
      </div>)
  }

  fun getWalletInfo : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/wallet/" + address)
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with wallet")

      result =
        decode json as ApiResponseWallet

      next { walletInfo = Maybe.just(result.result) }
    } catch {
      next { error = "Could not fetch wallet info" }
    }
  }

  fun isMineStyle (isMine : Bool) : Html {
    if (isMine) {
      <span class="text-primary ti-user"/>
    } else {
      <span/>
    }
  }

  fun isLockedStyle (isLocked : Bool) : Html {
    if (isLocked) {
      <span class="text-danger ti-lock"/>
    } else {
      <span class="text-success ti-key"/>
    }
  }

  fun tokenTable (tokens : Array(ApiAddressToken)) : Html {
    if (Array.isEmpty(tokensWithoutAxe)) {
      <span/>
    } else {
      <div class="table-responsive">
        <table class="table table-striped mb-0">
          <thead>
            <tr>
              <th>"Token"</th>

              <th/>

              <th>"Amount"</th>
            </tr>
          </thead>

          <tbody>
            for (token of tokensWithoutAxe) {
              <tr>
                <td>
                  <{ token.name }>
                </td>

                <td>
                  <{ isLockedStyle(token.isLocked) }>
                  <{ isMineStyle(token.isMine) }>
                </td>

                <td>
                  <{ token.amount }>
                </td>
              </tr>
            }
          </tbody>
        </table>
      </div>
    }
  } where {
    tokensWithoutAxe =
      tokens
      |> Array.reject(
        (token : ApiAddressToken) : Bool {
          (token.name
          |> String.toLowerCase()) == "axnt"
        })
  }
}
