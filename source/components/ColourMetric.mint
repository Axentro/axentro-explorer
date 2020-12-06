component ColourMetric {
  property title : String
  property value : Number
  property icon : String
  property colour : String

  fun render : Html {
    <div class={"card " + colour + " img-card overflow-hidden"}>
      <div class="card-body">
        <div class="d-flex">
          <div class="mr-5">
            <div class="ecommerce-icon">
              <i class={"fa fa-" + icon + " fa-3x text-white"}/>
            </div>
          </div>

          <div class="text-white mt-3">
            <p class="mb-1 font-weight-semibold fs-14">
              <{ title }>
            </p>

            <h2 class="mt-1 mb-0 fs-30 font-weight-bold ">
              <{ stringValue }>
            </h2>
          </div>
        </div>
      </div>

      <img
        src="../../assets/images/png/circle.png"
        alt="img"
        class="img-card-circle"/>
    </div>
  } where {
    stringValue =
      Number.toString(value)
  }
}
