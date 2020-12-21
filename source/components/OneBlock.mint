component OneBlock {
  connect Application exposing { blockId }
  state block : Maybe(ApiBlock) = Maybe.nothing()
  state error : String = ""

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      getBlock()
    }
  }

  fun componentDidUpdate : Promise(Never, Void) {
    sequence {
      getBlock()
    }
  }

  fun getBlock : Promise(Never, Void) {
    sequence {
      response =
        Http.get(Network.baseUrl() + "/api/v1/block/" + blockId)
        |> Http.send()

      json =
        Json.parse(response.body)
        |> Maybe.toResult("Json parsing error with transaction")

      result =
        decode json as ApiResponseSingleBlock

      next { block = Maybe.just(result.block.block) }
    } catch {
      next { error = "Could not fetch block" }
    }
  }

  fun render : Html {
    block
    |> Maybe.map(renderBlock)
    |> Maybe.withDefault(<div/>)
  }

  fun renderBlockKind (row : ApiBlock) : Html {
    if (row.kind == "SLOW") {
      <h6 class="tag tag-teal">
        "SLOW"
      </h6>
    } else {
      <h6 class="tag tag-pink">
        "FAST"
      </h6>
    }
  }

  fun renderTransactionCount (row : ApiBlock) : Html {
    <a href={"/blocks/" + blockId + "/transactions"}>
      <{
        count
        " transactions in this block"
      }>
    </a>
  } where {
    blockId =
      Number.toString(row.index)

    count =
      Number.toString(
        row.transactions
        |> Array.size)
  }

  fun renderAmount (row : ApiBlock) : Html {
    <h6 class="tag tag-blue">
      <{ amount }>

      <span class="tag-addon tag-azure">
        "  AXNT"
      </span>
    </h6>
  } where {
    amount =
      UiHelper.displayAmount(
        row.transactions
        |> Array.flatMap((t : ApiTransaction) { t.recipients })
        |> Array.map((r : ApiRecipient) { r.amount })
        |> Array.sum)
  }

  fun renderAge (row : ApiBlock) : String {
    UiHelper.timeAgo(row.timestamp)
  }

  fun renderDate (row : ApiBlock) : String {
    UiHelper.dateFrom(row.timestamp)
  }

  fun renderBlock (block : ApiBlock) : Html {
    <div class="card overflow-hidden">
      <div class="card-header">
        <h3 class="card-title">
          <{ "Block: " + blockId }>
        </h3>
      </div>

      <div class="card-body">
        <div class="table-responsive orders-table">
          <table
            id="example"
            class="table table-bordered text-nowrap  mb-0">

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Block id"
              </th>

              <td>
                <{ blockId }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Kind"
              </th>

              <td>
                <{ renderBlockKind(block) }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Age"
              </th>

              <td>
                <div>
                  <div>
                    <{ renderAge(block) }>
                  </div>

                  <div>
                    <{ renderDate(block) }>
                  </div>
                </div>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Address"
              </th>

              <td>
                <a href={"/address/" + block.address}>
                  <{ block.address }>
                </a>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Transactions"
              </th>

              <td>
                <{ renderTransactionCount(block) }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Difficulty"
              </th>

              <td>
                <{
                  block.difficulty
                  |> Maybe.map((d : Number) { Number.toString(d) })
                  |> Maybe.withDefault("Not applicable for " + block.kind + " block")
                }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Hash"
              </th>

              <td>
                <{
                  block.hash
                  |> Maybe.withDefault("Not applicable for " + block.kind + " block")
                }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Previous Hash"
              </th>

              <td>
                <{ block.previousHash }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Nonce"
              </th>

              <td>
                <{
                  block.nonce
                  |> Maybe.withDefault("Not applicable for " + block.kind + " block")
                }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Merkle Tree Root"
              </th>

              <td>
                <{ block.merkleTreeRoot }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Public Key"
              </th>

              <td>
                <{
                  block.publicKey
                  |> Maybe.withDefault("Not applicable for " + block.kind + " block")
                }>
              </td>
            </tr>

            <tr class="bold border-bottom">
              <th class="border-bottom-0">
                "Signature"
              </th>

              <td>
                <{
                  block.signature
                  |> Maybe.withDefault("Not applicable for " + block.kind + " block")
                }>
              </td>
            </tr>

          </table>
        </div>
      </div>
    </div>
  } where {
    blockId =
      Number.toString(block.index)
  }
}
