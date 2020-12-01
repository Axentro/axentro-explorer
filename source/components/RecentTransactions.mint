component RecentTransactions {

property transactions : Array(TransactionsResponse)

   fun sendersAndRecipients(row : TransactionsResponse) : Html {
       <div>
        <{ if (Array.isEmpty(senderAddresses)) { <div></div> } else { <div>"From: "<{renderAddresses(senderAddresses)}> </div>}}>
        <div>"To: "<{renderAddresses(recipientAddresses)}></div>
       </div>
   } where {
       senderAddresses = row.transaction.senders
       |> Array.map((s : ApiSender) { s.address })
       recipientAddresses = row.transaction.recipients
       |> Array.map((r : ApiRecipient) { r.address })
   }

   fun renderAddresses(addresses : Array(String)) : Array(Html) {
	   for (address of addresses) {
		   <div><a href={"/addresses/" + address}><{ UiHelper.capLength(address, 24)}></a></div>
       }
   }

   fun renderTransactionId(row : TransactionsResponse) : Html {
	   <div>
	   <a href={"/transactions/" + transactionId}><{ UiHelper.capLength(transactionId, 24)}></a>
	   <div><{ calculateTimeAgo(row) }></div>
	   </div>
   } where {
	   transactionId = row.transaction.id
   }

   fun calculateTimeAgo(row : TransactionsResponse) : String {
	   UiHelper.timeAgo(row.transaction.timestamp)
   }

   fun renderAmount(row : TransactionsResponse) : Html {
	<h6 class="tag tag-blue"><{amount}> <span class="tag-addon tag-azure">"  AXNT"</span></h6>   
   } where {
	   amount = UiHelper.displayAmount(row.transaction.recipients
	   |> Array.map((r : ApiRecipient) { r.amount })
	   |> Array.sum)
   }

   fun renderBodyRow(row : TransactionsResponse) : Html {
       <tr>
				
														<td class="text-muted"><{renderTransactionId(row)}></td>
														<td class="text-muted"><{sendersAndRecipients(row)}></td>
														<td class="text-muted"><{renderAmount(row)}></td>
													</tr>
   }





   fun render : Html {
       <div class="card overflow-hidden">
									<div class="card-header">
									<div class="col-md-12">
										<div class="float-left">
											<h3 class="card-title">"Latest Transactions"</h3> 
									    </div>
										<div class="float-right">		
											<a href="/transactions" class="btn btn-app btn-indigo"><i class="fa fa-tasks"></i>"  View all transactions"</a> 
										</div>
										</div>
									</div>
									<div class="card-body">
										<div class="table-responsive orders-table">
											<table id="example" class="table table-bordered text-nowrap  mb-0">
												<thead>
													<tr class="bold border-bottom">
														<th class="border-bottom-0">"Transaction id"</th>
														<th class="border-bottom-0">"From / To"</th>
														<th class="border-bottom-0">"Amount"</th>
													</tr>
												</thead>

                                                 <tbody>
                                               for (row of transactions) {
                                                 renderBodyRow(row)
                                                }
                                                 </tbody>
												
											</table>
										</div>
									</div>
									</div>
   }

}