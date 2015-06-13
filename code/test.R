library(cabaceo)
library(methods)
library(rvest)
library(XML)

## kmart
url = "http://www.kmart.com/essential-home-belmont-4-drawer-dresser-chest-black/p-021W003470856000P?vName=&cName=&sName="
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text() %>% gsub("[\r\n]", "", .))

# get price
(price_head = page %>% html_nodes("span.text") %>% html_text() %>% gsub("[: ]", "", .))
price_head[3] = "Price"
(price = page %>% html_nodes("span.pricing") %>% html_text())
names(price) = price_head
price

# get status
(status = page %>% html_nodes("span.ffmentStock") %>% html_text())

## amazon
url = "http://www.amazon.com/Mr-Heater-F232000-Indoor-Safe-Portable/dp/B002G51BZU"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price_head = page %>% 
         html_nodes("td.a-color-secondary.a-size-base.a-text-right.a-nowrap") %>% 
         html_text())
(price_head = strip(price_head, ":"))
(price = page %>% html_nodes("td.a-span12") %>% html_text() %>% 
         gsub("[a-zA-Z&\t\n ]|\\(.*\\)", "", .))
(price = price %>% gsub("\\.$", "", .))
names(price) = price_head
price

# get status
page %>% html_nodes("span.a-size-medium.a-color-price") %>% html_text()
(status = page %>% html_nodes("span.a-size-medium.a-color-success") %>% 
         html_text() %>% gsub("\n| |\\.", "", .))


## walmart
url = "http://www.walmart.com/ip/34973878"
# url = "http://www.walmart.com/ip/GreenWorks-Tools-12-Snow-Shovel/21403946"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes(".price-display") %>% html_text() %>% gsub(" ", "", .))

# get status
(status = page %>% html_nodes(".price-oos") %>% html_text())
if (length(status)==0) status = "in stock"
status


## overstock
url = "http://www.overstock.com/Home-Garden/Normandy-Tobacco-Brown-End-Table/6669192/product.html?refccid=H2AFIWSBDJR2EESCYO26KCZIMM&searchidx=23"
# url = "http://www.overstock.com/Home-Garden/The-Hilton-Curved-Graphite-Loveseat/5291390/product.html"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes(".price-title+ span") %>% html_text())

# get status
(status = page %>% html_nodes(".important") %>% html_text())

## wayfair
url = "http://www.wayfair.com/Delta-Children-Minnie-Mouse-Kids-3-Piece-Table-and-Chair-Set-TT89444MN-DEL1483.html"
# url = "http://www.wayfair.com/Delta-Children-Disney-Minnie-Mouse-Kids-Club-Chair-TC85689MN-DEL1510.html"
page = html(url, encoding="UTF-8")

doc = htmlParse(url, useInternalNodes=T)

# get title
title = xpathSApply(doc, "/*/head/meta[@property='og:title']/@content")
names(title) = NULL
title

# get price
price = xpathSApply(doc, "/*/head/meta[@property='og:price:amount']/@content")
names(price) = NULL
if (!grepl("/$", price)) price = paste0("$", price)
price

# get status
status_url = xpathSApply(doc, "//link[@itemprop='availability']/@href")
names(status_url) = NULL
if (length(status_url) != 0) {
        a = strsplit(status, "/")[[1]]
        status = a[length(a)]
} else { status = "in stock" }
status

## monoprice
url = "http://www.monoprice.com/Product?c_id=112&cp_id=11213&cs_id=1121303&p_id=12406&seq=1&format=2"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes(".price") %>% html_text() %>% gsub("\r\n| ", "", .))

# get status
(status = page %>% html_nodes("hr+ div .greenText") %>% html_text())

## sears
url = "http://www.sears.com/craftsman-evolv-101-pc-mechanics-tool-set/p-00910025000P"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes("#p0_price h4") %>% html_text() %>% gsub("\n| ", "", .))

# get status
(status = page %>% html_nodes(".product-fulfillment-max-ships-for span") %>% html_text())

## costco - 403 Forbidden
url = "http://www.costco.com/.product.100069986.html?cm_sp=RichRelevance-_-categorypageHorizontalTop-_-CategoryTopProducts&cm_vc=categorypageHorizontalTop|CategoryTopProducts"
page = html(url, encoding="UTF-8")

## samsclub
url = "http://www.samsclub.com/sams/augason-farms-30-day-food-storage-emergency-all-in-one-pail/prod5610448.ip"
page = html(url, encoding="UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes(".price+ .superscript , .price") %>% html_text() )
(price = paste0("$", paste(price, collapse=".")))

# get status
(status = page %>% html_nodes(xpath="//div[@data-onlinestatus='inStock']") %>% 
         html_text() %>% gsub("\n|\t*", "", .))
(status = ifelse(nchar(status) > 0, "in stock", "out of stock"))

## cabelas
url = "http://www.cabelas.com/product/Camping/Camp-Bedding/Sleeping-Pads%7C/pc/104795280/c/104712480/sc/104484780/Venture-Outdoorsreg-Ultra-Comfort-Contoured-Camping-Mat/1524433.uts?destination=%2Fcatalog%2Fbrowse%2Fsleeping-pads%2F_%2FN-1100678%2FNs-CATEGORY_SEQ_104484780%3FWTz_l%3DSBC%253BMMcat104795280%253Bcat104712480&WTz_l=SBC%3BMMcat104795280%3Bcat104712480%3Bcat104484780"
page = html(url, encoding = "UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes("dd") %>% html_text())
(price = price[1])

# get status
(status = page %>% html_nodes(".stockMessage") %>% html_text() %>% gsub("\n|\t| ", "", .))


## harborfreight
url = "http://www.harborfreight.com/tool-storage/workbench/multipurpose-workbench-with-light-60723.html"
page = html(url, encoding = "UTF-8")

# get title
(title = page %>% html_nodes("title") %>% html_text())

# get price
(price = page %>% html_nodes(".sale .price-label+ span") %>% html_text() %>% gsub("\n| ", "", .))

# get status
doc = htmlParse(url, useInternalNodes=T)
status = xpathSApply(doc, "//meta[@property='og:availability']/@content")
names(status) = NULL
status
