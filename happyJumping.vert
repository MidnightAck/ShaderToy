float map( in vec3 pos)
{
	float d1 = length(pos)-0.25;
    float d2 = pos.y- (-0.25);
    
    return min(d1,d2);
}

vec3 calcNormal(in vec3 pos)
{
    vec2 e=vec2(0.0001,0.0);
	return normalize(vec3(map(pos+e.xyy)-map(pos-e.xyy),
                          map(pos+e.yxy)-map(pos-e.yxy),
                          map(pos+e.yyx)-map(pos-e.yyx)));
}
	

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec2 p = (2.0*fragCoord-iResolution.xy)/min(iResolution.x,iResolution.y);
    
	vec3 ro = vec3(0.0,0.0,1.0);
    vec3 rd = normalize(vec3(p,-1.5));
    
    vec3 col = vec3(0.0);

    float t = 0.0;
    for(int i=0;i<100;++i)
    {
    	vec3 pos = ro + t*rd;
    	
        float h = map(pos);
        if(h<0.001)	break;
        t+=h;
        if(t>20.0)	break;
    }
    
    if(t<20.0)
    {
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal(pos);
        
        vec3 sun_dir = normalize(vec3(0.8,0.4,0.2) );
        float dif = clamp( dot(nor,sun_dir),0.0,1.0);
        
        float sky_dif = clamp( 0.5+0.5*dot(nor ,vec3(0.0,1.0,0.0)),0.0,1.0);
        
        col=vec3(1.0,0.7,0.5)*dif;
        col += vec3(0.0,0.1,0.3)*sky_dif;
        
        
    }
    
    fragColor = vec4(col,1.0);
}