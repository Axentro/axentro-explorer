component Address {
  connect TransactionStore exposing { address }

  fun render : Html {
    <Layout
      navigation=[<Navigation current="transactions"/>]
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

                <a href={"/address/" + address}>
                  <{ "Address " + address }>
                </a>

              </li>
            </ol>
          </div>

          <div class="page-rightheader"/>
        </div>

        <div class="row">
          <div class="col-lg-4 col-12">
            <WalletBalance/>
          </div>

          <div class="col-lg-8 col-12">
            <AllTransactions/>
          </div>
        </div>
      </div>
    </div>
  }
}
