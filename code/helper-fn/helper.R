retrieve = function(url, supplier) {
        # Extract title, price, and status 
        #
        # Args:
        #       url     :    string
        #       supplier:    string, ex: "amazon", "overstock"
        tryCatch({
                switch(supplier, 
                       kmart = kmart(url), amazon = amazon(url), 
                       walmart = walmart(url), overstock = overstock(url), 
                       wayfair = wayfair(url), monoprice = monoprice(url), 
                       sears = sears(url), samsclub = samsclub(url), 
                       cabelas=cabelas(url), harborfreight=harborfreight(url))                
        }, error = function(e) { 
                print(url)
        })

}

# # unit test
# url = "http://www.kmart.com/essential-home-belmont-4-drawer-dresser-chest-black/p-021W003470856000P?vName=&cName=&sName="
# retrieve(url, "kmart")

