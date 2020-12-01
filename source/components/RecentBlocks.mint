component RecentBlocks {

property blocks : Array(BlocksResponse)

  fun renderBodyRow(row : BlocksResponse) : Html {
	  <tr>
	  <td class="text-muted"><{renderBlockId(row)}></td>
														<td class="text-muted"><{renderBlockKind(row)}></td>
														<td class="text-muted"><{renderAmount(row)}></td>
	  </tr>
  }

  fun renderBlockKind(row : BlocksResponse) : Html {
	  if (row.kind == "SLOW") {
        <h6 class="tag tag-teal">"SLOW"</h6>
	  } else {
         <h6 class="tag tag-pink">"FAST"</h6>
	  }
  }


 fun renderAmount(row : BlocksResponse) : Html {
	<h6 class="tag tag-blue"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>   
   } where {
	   amount = UiHelper.displayAmount(
	   row.transactions
	   |> Array.flatMap((t : ApiTransaction) { t.recipients })
	   |> Array.map((r : ApiRecipient) { r.amount })
	   |> Array.sum)
   }

   fun renderBlockId(row : BlocksResponse) : Html {
	   <div>
	   <a href={"/blocks/" + blockId}><{ blockId }></a>
	   <div><{ calculateTimeAgo(row) }></div>
	   </div>
   } where {
	   blockId = Number.toString(row.index)
   }

   fun calculateTimeAgo(row : BlocksResponse) : String {
	   UiHelper.timeAgo(row.timestamp)
   }

   fun render : Html {
       <div class="card overflow-hidden">
									<div class="card-header">
										<div class="col-md-12">
										<div class="float-left">
											<h3 class="card-title">"Latest Blocks"</h3> 
									    </div>
										<div class="float-right">		
											<a href="/blocks" class="btn btn-app btn-indigo"><i class="fa fa-cube"></i>"  View all blocks"</a> 
										</div>
										</div>
									</div>
									<div class="card-body">
										<div class="table-responsive orders-table">
											<table id="example" class="table table-bordered text-nowrap  mb-0">
												<thead>
													<tr class="bold border-bottom">
														<th class="border-bottom-0">"Block id"</th>
														<th class="border-bottom-0">"Kind"</th>
														<th class="border-bottom-0">"Amount"</th>
													</tr>
												</thead>
												  <tbody>
                                               for (row of blocks) {
                                                 renderBodyRow(row)
                                                }
                                                 </tbody>
											</table>
										</div>
									</div>
									</div>
   }

}