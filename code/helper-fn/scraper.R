kmart = function(url) {
        url = "http://www.kmart.com/essential-home-belmont-4-drawer-dresser-chest-black/p-021W003470856000P?vName=&cName=&sName="

        page = html(url, encoding="UTF-8")
        
        # get title
        title = page %>% html_nodes("title") %>% html_text() %>% 
                gsub("[\r\n]", "", .)
        
        # get price
#         price_head = page %>% html_nodes("span.text") %>% html_text() %>% 
#                 gsub("[: ]", "", .)
#         price_head[3] = "Price"
        price = page %>% html_nodes("span.pricing") %>% html_text()
        price = price[3]
        
        # get status
        status = page %>% html_nodes("span.ffmentStock") %>% html_text()
        status = status[1]

        # return a data frame
        data.frame(price=price, status=status)
}

amazon = function(url) {
#         url = "http://www.amazon.com/Mr-Heater-F232000-Indoor-Safe-Portable/dp/B002G51BZU"
#         url = "http://www.amazon.com/Lifetime-Personal-20-Inch-Molded-Almond/dp/B0006D50RE"
#         url = "http://www.amazon.com/dp/B003Z74GKU/ref=wl_it_dp_o_pC_nS_ttl?_encoding=UTF8&colid=21OV10WCQUK6E&coliid=I2CNI11ORVQEDN"
#         url = "http://www.amazon.com/Otter-200827-Parent-Sport-Sled/dp/B00GZIYPLG/ref=pd_sim_sbs_sg_5?ie=UTF8&refRID=0YJWJPP2J8KRP68ZGTHN"
#         page = html(url, encoding="UTF-8")
        
        # get title
        (title = page %>% html_nodes("title") %>% html_text())
        
        # get price
        price = page %>% html_nodes("span.a-size-medium.a-color-price") %>% html_text() 
        (price = price[length(price)])
                
        # get status
        (status = page %>% html_nodes(xpath="//div[@id='availability']") %>% 
                 html_text() %>% gsub("\n|\\.| ", "", .))
        if (grepl("Usuallyship|Instock", status)) status = "in stock"

        # return a data frame
        data.frame(price=price, status=status)
}

walmart = function(url) {
#         url = "http://www.walmart.com/ip/34973878"
#         url = "http://www.walmart.com/ip/GreenWorks-Tools-12-Snow-Shovel/21403946"
        url = "http://www.walmart.com/ip/25508439?registryId=99803054288&listId=87ed95a6-3fa2-4e30-b6e8-bde6b29a7955&listType=WL"
        page = html(url, encoding="UTF-8")
        
        # get title
        title = page %>% html_nodes("title") %>% html_text()
        
        # get price
        price = page %>% html_nodes(".price-display") %>% html_text() %>% 
                gsub(" ", "", .)
        
        # get status
        status = page %>% html_nodes(".price-oos") %>% html_text()
        if (length(status)==0) status = "in stock"
        
        # return a data frame
        data.frame(price=price, status=status)        
}

overstock = function(url) {
#         url = "http://www.overstock.com/Home-Garden/Normandy-Tobacco-Brown-End-Table/6669192/product.html?refccid=H2AFIWSBDJR2EESCYO26KCZIMM&searchidx=23"
#         url = "http://www.overstock.com/Home-Garden/The-Hilton-Curved-Graphite-Loveseat/5291390/product.html"
        
#         page = html(url, encoding="UTF-8")        
#         
#         # get title
#         title = page %>% html_nodes("title") %>% html_text()
#         
#         # get price
#         price = page %>% html_nodes(xpath="//span[@itemprop='price']") %>% 
#                 html_text() %>% gsub("\n| ", "", .)
        
        doc = htmlParse(url)

        # get title, price, and status
        title = doc['//title'] %>% html_text()        
        price = doc['//span[@itemprop="price"]'] %>% html_text() %>% 
                gsub("\n| ", "", .)
        status = doc['//div[@class="status-label important"]'] %>% html_text() 
        if (length(status) == 0) status = "in stock"
        
        # return a data frame
        data.frame(price=price, status=status)        
}

wayfair = function(url) {
#         url = "http://www.wayfair.com/Delta-Children-Minnie-Mouse-Kids-3-Piece-Table-and-Chair-Set-TT89444MN-DEL1483.html"
#         url = "http://www.wayfair.com/Delta-Children-Disney-Minnie-Mouse-Kids-Club-Chair-TC85689MN-DEL1510.html"
        
        doc = htmlParse(url, useInternalNodes=T)
        
        # get title
        title = xpathSApply(doc, "/*/head/meta[@property='og:title']/@content")
        names(title) = NULL
        
        # get price
        price = xpathSApply(doc, "/*/head/meta[@property='og:price:amount']/@content")
        names(price) = NULL
        if (!grepl("/$", price)) price = paste0("$", price)
        
        # get status
        status_url = xpathSApply(doc, "//link[@itemprop='availability']/@href")
        names(status_url) = NULL
        status = "in stock"
        if (length(status_url) != 0) {
                a = strsplit(status, "/")[[1]]
                status = a[length(a)]
        }
        
        # return a data frame
        data.frame(price=price, status=status)        
}

monoprice = function(url) {
#         url = "http://www.monoprice.com/Product?c_id=112&cp_id=11213&cs_id=1121303&p_id=12406&seq=1&format=2"
        page = html(url, encoding="UTF-8")
        
        # get title
        (title = page %>% html_nodes("title") %>% html_text())
        
        # get price
        (price = page %>% html_nodes(".price") %>% html_text() %>% gsub("\r\n| ", "", .))
        
        # get status
        (status = page %>% html_nodes("hr+ div .greenText") %>% html_text())

        # return a data frame
        data.frame(price=price, status=status)
}

sears = function(url) {
#         url = "http://www.sears.com/craftsman-evolv-101-pc-mechanics-tool-set/p-00910025000P"
        page = html(url, encoding="UTF-8")
        
        # get title
        (title = page %>% html_nodes("title") %>% html_text())
        
        # get price
        (price = page %>% html_nodes("#p0_price h4") %>% html_text() %>% gsub("\n| ", "", .))
        
        # get status
        (status = page %>% html_nodes(".product-fulfillment-max-ships-for span") %>% html_text())

        # return a data frame
        data.frame(price=price, status=status)
}

samsclub = function(url) {
#         url = "http://www.samsclub.com/sams/augason-farms-30-day-food-storage-emergency-all-in-one-pail/prod5610448.ip"
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
        
        # return a data frame
        data.frame(price=price, status=status)
}

cabelas = function(url) {
#         url = "http://www.cabelas.com/product/Camping/Camp-Bedding/Sleeping-Pads%7C/pc/104795280/c/104712480/sc/104484780/Venture-Outdoorsreg-Ultra-Comfort-Contoured-Camping-Mat/1524433.uts?destination=%2Fcatalog%2Fbrowse%2Fsleeping-pads%2F_%2FN-1100678%2FNs-CATEGORY_SEQ_104484780%3FWTz_l%3DSBC%253BMMcat104795280%253Bcat104712480&WTz_l=SBC%3BMMcat104795280%3Bcat104712480%3Bcat104484780"
        page = html(url, encoding = "UTF-8")
        
        # get title
        (title = page %>% html_nodes("title") %>% html_text())
        
        # get price
        (price = page %>% html_nodes("dd") %>% html_text())
        (price = price[1])
        
        # get status
        (status = page %>% html_nodes(".stockMessage") %>% html_text() %>% gsub("\n|\t| ", "", .))        
        
        # return a data frame
        data.frame(price=price, status=status)
}

harborfreight = function(url) {
#         url = "http://www.harborfreight.com/tool-storage/workbench/multipurpose-workbench-with-light-60723.html"
        page = html(url, encoding = "UTF-8")
        
        # get title
        (title = page %>% html_nodes("title") %>% html_text())
        
        # get price
        (price = page %>% html_nodes(".sale .price-label+ span") %>% html_text() %>% gsub("\n| ", "", .))
        
        # get status
        doc = htmlParse(url, useInternalNodes=T)
        status = xpathSApply(doc, "//meta[@property='og:availability']/@content")
        names(status) = NULL     
        
        # return a data frame
        data.frame(price=price, status=status)        
}
