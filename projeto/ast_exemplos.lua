require "comandos"

-- EXEMPLOS DE EXPRESSOES

-- local ast = node("mul", {
-- 		node("2",nil),
-- 		node("add", {
-- 			node("3",nil),
-- 			node("1",nil)
-- 			})
-- 	})

-- local ast = node("eq", {
-- 		node("2",nil),
-- 		node("3",nil)
-- 	})

-- local ast = node("not", {
-- 		node("eq", {
-- 			node("2",nil),
-- 			node("2",nil)
-- 		})
-- 	})

-- local ast = node("att", {
-- 		node("a",nil),
-- 		node("143",nil)
-- 	})

-- local ast = node("att", {
-- 		node("a",nil),
-- 		node("add", {
-- 			node("a",nil),
-- 			node("a",nil)
-- 			})
-- 	})

-- local ast = node("or", {
-- 		node("ff",nil),
-- 		node("eq", {
-- 			node("a",nil),
-- 			node("8",nil)
-- 			})
-- 	})

-- local ast = node("att", {
--   node("z", nil),   
--   node("if", {
--       node("eq", {
--         node("1", nil),
--         node("2", nil)
--       }),
--       node("add",{
--         node("1", nil),
--         node("2", nil)
--       }),
--       node("add",{
--         node("2", nil),
--         node("3", nil)
--       }),
--   })
-- })

-- tree.show(ast)

-- resolverExpressoes(0,s,m,c,ast)

-- print()
-- print("Resultado final: ")
-- printSMC(e,s,m,c)






-- EXEMPLOS DE COMANDOS 



-- while
 -- local ast = node("while", {
 -- 	node("eq", {
 -- 		node("a", nil), 
 -- 		node("7", nil)
 -- 		}), 
 -- 		node("att", {
 -- 			node("a", nil), 
 -- 			node("add", {
 -- 				node("a", nil), 
 -- 				node("3", nil) 
 -- 				})
 -- 			})
 -- 		})

-- local ast = node(";", {
-- 		node("att", {
-- 			node("a",nil),
-- 			node("13",nil)
-- 			}),
-- 		node("att", {
-- 			node("b",nil),
-- 			node("14",nil)
-- 			})
-- 	})

-- local ast = node(";", {
-- 		node("if", {
-- 		node("eq", {
-- 			node("5",nil), 
-- 			node("5",nil)
-- 			}), 
-- 		node("att", { --then
-- 			node("b",nil), 
-- 			node("102", nil)
-- 			}), 
-- 		node("att", { --else
-- 			node("b", nil),
-- 			node("103", nil)
-- 			})
-- 		}),
-- 			node("if", {
-- 		node("eq", {
-- 			node("4",nil), 
-- 			node("4",nil)
-- 			}), 
-- 		node("att", { --then
-- 			node("a",nil), 
-- 			node("22", nil)
-- 			}), 
-- 		node("att", { --else
-- 			node("a", nil),
-- 			node("33", nil)
-- 			})
-- 		})
-- 	})

 -- local ast = node("while", {
 -- 	node("not", {
 -- 		node("eq", {
 -- 			node("a",nil),
 -- 			node("10",nil),
 -- 			})
 -- 		}),
 -- 	node("att", {
 -- 		node("a",nil),
 -- 		node("add", {
 -- 			node("a",nil),
 -- 			node("1",nil)
 -- 			})
 -- 		})
 -- 	})

 -- local ast = node("while", { --fatorial
 -- 	node("not", {
 -- 		node("eq", {
 -- 			node("fat",nil),
 -- 			node("0",nil),
 -- 			})
 -- 		}),
 -- 	node(";", {
 -- 			node("att", {
	--  		node("result",nil),
	--  		node("mul", {
	--  			node("result",nil),
	--  			node("fat",nil)
	--  			})
	--  		}),
	--  	node("att", {
	--  		node("fat",nil),
	--  		node("sub", {
	--  			node("fat",nil),
	--  			node("1",nil)
	--  			})
	--  		})
 -- 		})
 -- 	})

-- local ast = node("if", {
-- 	node("eq", {
-- 		node("5",nil), 
-- 		node("4",nil)
-- 		}), 
-- 	node("att", { --then
-- 		node("a",nil), 
-- 		node("2", nil)
-- 		}), 
-- 	node("att", { --else
-- 		node("a", nil),
-- 		node("3", nil)
-- 		})
-- 	})

--[[local ast = node("while", {
	node("eq", {
		node("a", nil), 
		node("1", nil)
		}), 
	node("att", {
		node("1", nil), 
		node("2", nil)
		})
	})--]]

-- local ast = node(";", {
-- 	node("var", {
-- 		node("y", nil),
-- 		node("7",nil)
-- 	}),
-- 	node("var", {
-- 		node("x", nil),
-- 		node("3",nil)
-- 		}),
-- 	node("var", {
-- 		node("z", nil),
-- 		node("9",nil)
-- 		}),
-- 	node("att", {
-- 		node("y", nil),
-- 		node("add",{
-- 			node("z",nil),
-- 			node("x",nil)
-- 			})
-- 		})
-- 	})

-- local ast=node(";",{
-- 	node("if",{
-- 		node("eq",{
-- 			node("1",nil),
-- 			node("1",nil)
-- 			}),
-- 		node("var",{
-- 			node("x", nil),
-- 			node("3", nil)
-- 		}),
-- 		node("var",{
-- 			node("y",nil),
-- 			node("0",nil)
-- 		})
-- 	}),
-- 	node("att",{
-- 		node("x",nil),
-- 		node("9",nil)
-- 	})
-- })

-- local ast = node(";",{
-- 		node("var",{
-- 			node("x", nil),
-- 			node("2",nil)
-- 		})
-- 	})

-- local ast = node(";",{
-- 		node("const",{
-- 			node("a",nil),
-- 			node("2",nil)
-- 		}),
-- 		node("att",{
-- 			node("a", nil),
-- 			node("9", nil)
-- 		})
-- 	})



print("\n\n\n\n\n\nÁrvore:\n")
tree.show(ast)
resolverComandos(e, s, m, c, ast)
print("Final")
printSMC(e,s,m,c)

-- if
--local ast = node(";", {node("<", {node("1", nil), node("2", nil)}), node("", ) , node("", )})