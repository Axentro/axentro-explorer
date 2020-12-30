module UiHelper {
  fun capLength (value : String, length : Number) : String {
    (value
    |> String.split("")
    |> Array.take(length)
    |> String.join("")) + "..."
  }

  fun displayAmount (value : Number) : String {
    `new Decimal(#{value} / 100000000).toString()`
  }

  fun timeAgo (millis : Number) : String {
    `timeago().format(#{millis})`
  }

  fun dateFrom (millis : Number) : String {
    `new Date(#{millis}).toString()`
  }

  fun shortDateFrom(millis : Number) : String {
    `moment(#{millis}).format("DD/MM/YYYY, HH:mm:ss")`
  }

  fun roundUp (value : Number) : Number {
    `Math.ceil(#{value})`
  }

   fun roundDown (value : Number) : Number {
    `Math.floor(#{value})`
  }

  fun selectNameOptions (selectedName : String, options : Array(String)) : Array(Html) {
    options
    |> Array.map(
      (opt : String) : Html { renderSelectOption(opt, selectedName) })
  }

  fun submitOnEnter (
    event : Html.Event,
    callback : Function(Html.Event, Promise(Never, Void))
  ) : Promise(Never, Void) {
    if (event.charCode == 13) {
      callback(event)
    } else {
      Promise.never()
    }
  }

  fun renderSelectOption (opt : String, currentlySelected : String) : Html {
    if (opt == currentlySelected) {
      <option
        value={opt}
        selected="true">

        <{ opt }>

      </option>
    } else {
      <option value={opt}>
        <{ opt }>
      </option>
    }
  }
}
