Set
    p     / p1*p10 /
    t     / m1*m12 /;
    
Alias (t, tp);

Parameters
    demand(p, t)
    productionCost(p)
    holdingCost(p)
    setupCost(p)
    capacityRequirement(p)
    capacity(t)
    bigM(p)
    initialInventory(p);
    
productionCost(p) = 20;
holdingCost(p) = 1;
setupCost(p) = 500;
capacityRequirement(p) = 1;
capacity(t) = 800;
bigM(p) = 800;
initialInventory(p) = 0;
initialInventory('p4') = 75;
initialInventory('p7') = 225;

demand(p, t) = 35;
demand(p, 'm7') = 80;
demand(p, 'm8') = 85;
demand(p, 'm9') = 115;

* x -> uretim miktari
* y -> setup binary degisken
Variables
    Z
    x(p, t)
    inventory(p, t)
    y(p, t);
    
Binary Variable y;
Positive Variables x, inventory;

Equations
    obj
    inventoryInit(p)
    inventoryBalance(p, t)
    capacityConstraint(t)
    setupLink(p, t);
    
obj..
    Z =e= sum((p, t), productionCost(p) * x(p, t) + holdingCost(p) * inventory(p, t) + setupCost(p) * y(p, t));
    
inventoryInit(p)..
    initialInventory(p) + x(p, 'm1') =e= demand(p, 'm1') + inventory(p, 'm1');
    
inventoryBalance(p, t)$(ord(t) > 1)..
    inventory(p, t)
    =e= sum(tp$(ord(tp) = ord(t) - 1), inventory(p, tp))
    + x(p, t)
    - demand(p, t);
    
capacityConstraint(t)..
    sum(p, capacityRequirement(p) * x(p, t)) =l= capacity(t);
    
setupLink(p, t)..
    x(p, t) =l= bigM(p) * y(p, t);
    
Model MultiProductionPlan /all/;

Solve MultiProductionPlan using mip minimizing Z;
