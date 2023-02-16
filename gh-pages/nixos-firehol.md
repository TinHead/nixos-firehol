## services.firehol.enable

Whether to enable Firehol firewall for humans!.

#### type

boolean

#### example

```nix
{
  services.firehol.enable = true;
}
```

#### default

```nix
{
  services.firehol.enable = false;
}
```


## services.firehol.interfaces

List of interfaces to use 

#### type

(attribute set of (submodule)) or (list of (attribute set)) convertible to it

#### example

```nix
{
  services.firehol.interfaces = {
    eth1 = {
      myname = "lan";
    };
  };
}
```

#### default

```nix
{
  services.firehol.interfaces = {};
}
```


## services.firehol.interfaces.&lt;name&gt;.dst



#### type

submodule


#### default

```nix
{
  services.firehol.interfaces.<name>.dst = {};
}
```


## services.firehol.interfaces.&lt;name&gt;.dst.deny



#### type

boolean


#### default

```nix
{
  services.firehol.interfaces.<name>.dst.deny = false;
}
```


## services.firehol.interfaces.&lt;name&gt;.dst.ip



#### type

string


#### default

```nix
{
  services.firehol.interfaces.<name>.dst.ip = "";
}
```


## services.firehol.interfaces.&lt;name&gt;.myname

Interface custom name for readability

#### type

string


#### default

```nix
{
  services.firehol.interfaces.<name>.myname = "lan";
}
```


## services.firehol.interfaces.&lt;name&gt;.name

Interface name

#### type

string


#### default

```nix
{
  services.firehol.interfaces.<name>.name = "‹name›";
}
```


## services.firehol.interfaces.&lt;name&gt;.policy

Default policy on this interface

#### type

one of "accept", "reject", "drop"


#### default

```nix
{
  services.firehol.interfaces.<name>.policy = "drop";
}
```


## services.firehol.interfaces.&lt;name&gt;.rules



#### type

list of string


#### default

```nix
{
  services.firehol.interfaces.<name>.rules = [
    "client all accept"
  ];
}
```


## services.firehol.interfaces.&lt;name&gt;.src



#### type

submodule


#### default

```nix
{
  services.firehol.interfaces.<name>.src = {};
}
```


## services.firehol.interfaces.&lt;name&gt;.src.deny



#### type

boolean


#### default

```nix
{
  services.firehol.interfaces.<name>.src.deny = false;
}
```


## services.firehol.interfaces.&lt;name&gt;.src.ip



#### type

string


#### default

```nix
{
  services.firehol.interfaces.<name>.src.ip = "";
}
```


## services.firehol.routers

List of Routers to create 

#### type

(attribute set of (submodule)) or (list of (attribute set)) convertible to it

#### example

```nix
{
  services.firehol.routers = {
    lan2wan = {};
  };
}
```

#### default

```nix
{
  services.firehol.routers = {};
}
```


## services.firehol.routers.&lt;name&gt;.dst



#### type

submodule


#### default

```nix
{
  services.firehol.routers.<name>.dst = {};
}
```


## services.firehol.routers.&lt;name&gt;.dst.deny



#### type

boolean


#### default

```nix
{
  services.firehol.routers.<name>.dst.deny = false;
}
```


## services.firehol.routers.&lt;name&gt;.dst.ip



#### type

string


#### default

```nix
{
  services.firehol.routers.<name>.dst.ip = "";
}
```


## services.firehol.routers.&lt;name&gt;.inface

Input interface

#### type

string


#### default

```nix
{
  services.firehol.routers.<name>.inface = "lan";
}
```


## services.firehol.routers.&lt;name&gt;.name

Router name

#### type

string


#### default

```nix
{
  services.firehol.routers.<name>.name = "‹name›";
}
```


## services.firehol.routers.&lt;name&gt;.outface

Output interface

#### type

string


#### default

```nix
{
  services.firehol.routers.<name>.outface = "";
}
```


## services.firehol.routers.&lt;name&gt;.rules



#### type

list of string


#### default

```nix
{
  services.firehol.routers.<name>.rules = [
    "client all accept"
  ];
}
```


## services.firehol.routers.&lt;name&gt;.src



#### type

submodule


#### default

```nix
{
  services.firehol.routers.<name>.src = {};
}
```


## services.firehol.routers.&lt;name&gt;.src.deny



#### type

boolean


#### default

```nix
{
  services.firehol.routers.<name>.src.deny = false;
}
```


## services.firehol.routers.&lt;name&gt;.src.ip



#### type

string


#### default

```nix
{
  services.firehol.routers.<name>.src.ip = "";
}
```

