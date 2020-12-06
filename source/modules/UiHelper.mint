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

  fun roundUp (value : Number) : Number {
    `Math.ceil(#{value})`
  }

  fun selectNameOptions (selectedName : String, options : Array(String)) : Array(Html) {
    options
    |> Array.map(
      (opt : String) : Html { renderSelectOption(opt, selectedName) })
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
