component Navigation {
  property current : String

  fun activeStyle (item : String) : String {
    if (item == current) {
      "active"
    } else {
      ""
    }
  }

  fun render : Html {
    <ul class="side-menu toggle-menu">
      <li class="slide">
        <a
          class={"side-menu__item " + activeStyle("dashboard")}
          href="/dashboard">

          <i class="side-menu__icon las la-home"/>

          <span class="side-menu__label">
            "Dashboard"
          </span>

        </a>
      </li>

      <li class="slide">
        <a
           class={"side-menu__item " + activeStyle("blocks")}
          href="/blocks">

          <i class="side-menu__icon las la-cube"/>

          <span class="side-menu__label">
            "Blocks"
          </span>

        </a>
      </li>

      <li class="slide">
        <a
           class={"side-menu__item " + activeStyle("transactions")}
          href="/transactions">

          <i class="side-menu__icon las la-tasks"/>

          <span class="side-menu__label">
            "Transactions"
          </span>

        </a>
      </li>
    </ul>
  }
}
