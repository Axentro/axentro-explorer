component Block {
  connect Application exposing { blockId }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="blocks"/>]
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

                <a href="/blocks">
                  "Blocks"
                </a>

              </li>

              <li
                class="breadcrumb-item active"
                aria-current="page">

                <a href={"/blocks/" + blockId}>
                  <{ "Block " + blockId }>
                </a>

              </li>
            </ol>
          </div>

          <div class="page-rightheader"/>
        </div>

        <div class="row row-deck">
          <div class="col-lg-12 col-12">
            <OneBlock/>
          </div>
        </div>
      </div>
    </div>
  }
}
