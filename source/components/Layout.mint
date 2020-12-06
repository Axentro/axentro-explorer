component Layout {
  property content : Array(Html) = []
  property navigation : Array(Html) = []

  fun componentDidMount : Promise(Never, Void) {
    sequence {
      LayoutHelper.preLoad()
    }
  }

  fun render : Html {
    <div class="app sidebar-mini dark-menu">
      <div class="page">
        <div class="page-main">
          <div
            class="app-sidebar__overlay"
            data-toggle="sidebar"/>

          <aside class="app-sidebar toggle-sidebar">
            <div class="app-sidebar__logo">
              <a
                class="header-brand"
                href="index.html">

                <img
                  src="../../assets/images/brand/axentro-logo.png"
                  class="header-brand-img desktop-lgo"
                  alt="zdash logo"/>

                <img
                  src="../../assets/images/brand/axentro-logo-light.png"
                  class="header-brand-img dark-logo"
                  alt="zdash logo"/>

                <img
                  src="../../assets/images/brand/axentro-icon.png"
                  class="header-brand-img mobile-logo"
                  alt="zdash logo"/>

                <img
                  src="../../assets/images/brand/axentro-icon.png"
                  class="header-brand-img darkmobile-logo"
                  alt="zdash logo"/>

              </a>
            </div>

            <Navigation/>
          </aside>

          <div class="app-header header">
            <div class="container-fluid">
              <div class="d-flex">
                <a
                  class="header-brand"
                  href="index.html">

                  <img
                    src="../../assets/images/brand/axentro-logo.png"
                    class="header-brand-img main-logo"
                    alt="Cino logo"/>

                  <img
                    src="../../assets/images/brand/axentro-logo-light.png"
                    class="header-brand-img dark-main-logo"
                    alt="Cino logo"/>

                  <img
                    src="../../assets/images/brand/axentro-icon.png"
                    class="header-brand-img dark-icon-logo"
                    alt="Cino logo"/>

                  <img
                    src="../../assets/images/brand/axentro-icon.png"
                    class="header-brand-img icon-logo"
                    alt="Cino logo"/>

                </a>

                <div
                  class="app-sidebar__toggle"
                  data-toggle="sidebar">

                  <a
                    class="open-toggle"
                    href="#">

                    <i class="fe fe-align-left"/>

                  </a>

                  <a
                    class="close-toggle"
                    href="#">

                    <i class="fe fe-x"/>

                  </a>

                </div>

                <form class="form-inline">
                  <div class="search-element">
                    <button
                      class="btn btn-primary-color"
                      type="submit">

                      <i class="fa fa-search"/>

                    </button>

                    <input
                      type="search"
                      class="form-control header-search"
                      placeholder="Search by Address / Txn Id / Block / Token / Hra"
                      aria-label="Search"
                      tabindex="1"/>
                  </div>
                </form>

                <div class="d-flex order-lg-2 ml-auto header-right"/>
              </div>
            </div>
          </div>

          <{ content }>

          <footer class="footer side-footer">
            <div class="container">
              <div class="row align-items-center flex-row-reverse">
                <div class="col-lg-12 col-sm-12   text-center"/>
              </div>
            </div>
          </footer>
        </div>
      </div>
    </div>
  }
}
