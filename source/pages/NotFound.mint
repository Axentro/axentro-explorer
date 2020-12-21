component NotFound {
  fun render : Html {
    <div class="error-page">
      <div class="page-content">
        <div class="container text-center text-dark">
          <div class="error-found">
            <h1 class="mb-0">
              "404"
            </h1>
          </div>

          <div class="error-text">
            "WE CAN'T FIND THIS PAGE!"
          </div>

          <div class="h4  mb-2">
            "We are very sorry for inconvenicence. "
          </div>

          <div class="h5">
            "Oops!"
          </div>

          <a
            class="btn btn-primary"
            href="/">

            "Go Back "

          </a>
        </div>
      </div>
    </div>
  }
}
