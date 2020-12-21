component NoSearch {
  connect Application exposing { searchTerm }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="dashboard"/>]
      content=[pageContent()]/>
  }

  fun pageContent : Html {
    <div class="app-content toggle-content">
      <div class="side-app">
        <div class="page-header">
          <div class="page-leftheader">
            <h1 class="page-title">
              " Axentro Blockchain Explorer"
            </h1>

            <ol class="breadcrumb">
              <li class="breadcrumb-item">
                <a href="/dashboard">
                  <i class="las la-home mr-2 fs-16"/>
                  "Dashboard"
                </a>
              </li>

              <li
                class="breadcrumb-item active"
                aria-current="page">

                <p>"Search"</p>

              </li>

              <li
                class="breadcrumb-item active"
                aria-current="page">

                <p>
                  <{ searchTerm }>
                </p>

              </li>
            </ol>
          </div>

          <div class="page-rightheader"/>
        </div>

        <div class="row row-deck">
          <div class="col-md-12 col-xl-4">
            <div class="card">
              <div class="card-status card-status-left bg-danger br-bl-3 br-tl-3"/>

              <div class="card-header">
                <h3 class="card-title">
                  "Search result not found"
                </h3>
              </div>

              <div class="card-body">
                <{ "Nothing found for the search term: " + searchTerm }>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  }
}
