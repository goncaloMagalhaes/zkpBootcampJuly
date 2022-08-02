
## Perform and log output of simple arithmetic operations
func simple_math():
    
    ## adding 13 +  14
    let a = 13 + 14
    %{ 
        print(ids.a)
    %}
    
    ## multiplying 3 * 6
    let b = 3 * 6
    %{ 
        print(ids.b) 
    %}

    ### dividing 6 by 2
    let c = 6 / 2
    %{ 
        print(ids.c) 
    %}
    
    ### dividing 70 by 2
    let d = 70 / 2
    %{ 
        print(ids.d) 
    %}
    
    ### dividing 7 by 2 
    let e = 7 / 2
    %{ 
        print(ids.e) 
    %}

    return ()
end