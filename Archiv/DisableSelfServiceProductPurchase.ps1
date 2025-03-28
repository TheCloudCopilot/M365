$products = Get-MSCommerceProductPolicies -PolicyId AllowSelfServicePurchase 
foreach ($prod in $products)

	{
		Update-MSCommerceProductPolicy -PolicyId AllowSelfServicePurchase -ProductId $prod.ProductId -Enabled $false
	}​ 