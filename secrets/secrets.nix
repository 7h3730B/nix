let 
  users = [

  ];

  systems = {

  };

  keysForSystems = list: users ++ (builtin.map (s: systems."${s}") list);
  in {

  }