require "comandos"

local ast = node(";", {
	node("Var",{
		node("NameList", {
			node("Id",{
				node("a", nil)
			})
		}),
		node("ExpList", {
			node("if",{
				node("Op",{
					node("==", nil),
					node("Number",{
						node("4", nil)
					}),
					node("Number", {
						node("3", nil)
					})
				}),
				node("5",nil),
				node("7",nil)	
			})
		})	
	})
})

local ast = node(";", {
	node("Var",{
		node("NameList", {
			node("Id",{
				node("a", nil)
			})
		}),
		node("0", nil)	
	}),
	node("Set", {
		node("VarList", {
			node("Id", {
				node("a", nil)
			}),
		}),
		node("ExpList", {
			node("if",{
				node("Op",{
					node("==", nil),
					node("Number",{
						node("4", nil)
					}),
					node("Number", {
						node("4", nil)
					})
				}),
				node("5",nil),
				node("7",nil)	
			})	
		})
	})
})

resolverComandos(e,s,m,c,o,ast)