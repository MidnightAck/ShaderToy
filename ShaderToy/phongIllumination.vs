const int MAX_MARCHING_STEPS = 255;
const float MIN_DIST = 0.0;
const float MAX_DIST = 100.0;
const float EPSILON = 0.0001;

float map(vec3 pos)
{
	float d = length(pos)-1.0;
    
    return d;
}

float rayCast(vec3 ro,vec3 rd)
{
	float t = 0.0;
    for(int i=0;i<MAX_MARCHING_STEPS;++i)
    {
    	vec3 pos = ro + t*rd;
       	float h = map(pos);
        if(h<EPSILON)	break;
        t += h;
        if(t>MAX_DIST)	break;
    }
    return min(MAX_DIST,t);
}

vec3 calcNormal(vec3 pos)
{
	vec2 e = vec2(0.0001,0.0);
    return normalize(vec3(map(e.xyy+pos)-map(pos-e.xyy),
                          map(e.yxy+pos)-map(pos-e.yxy),
                          map(e.yyx+pos)-map(pos-e.yyx) ) );
}

vec3 rayDir(in float fieldofView, vec2 size, vec2 fragCoord)
{
	vec2 xy = fragCoord - size/2.0;
    float z = size.y/tan(radians(fieldofView)/2.0);
    return normalize(vec3(xy,-z));
}

vec3 phongRef(vec3 pos, vec3 lightpos,vec3 ro,vec3 lightI,float alpha,vec3 k_d,vec3 k_s)
{
	vec3 N = calcNormal(pos);
    vec3 L = normalize(lightpos-pos);
    vec3 R = normalize(reflect(-L,N));
    vec3 V = normalize(ro - pos);
    
    float dotLN = dot(L,N);
    float dotRV = dot(R,V);
    
    if(dotLN<0.0)	return vec3(0.0);
    if(dotRV<0.0)	return lightI*k_d*dotLN;
    return lightI* (k_d * dotLN + k_s * pow(dotRV,alpha));
}

vec3 phongIllu(vec3 k_d,vec3 k_s,vec3 k_a,vec3 pos,vec3 ro)
{
    vec3 aLight = vec3(0.4,0.6,0.8);
    vec3 col = k_a * aLight;
	vec3 lightpos1 = vec3(4.0 * sin(iTime),2.0,4.0 * cos(iTime) );
    vec3 lightI1 = vec3(0.5,0.5,0.5);
    col += phongRef(pos,lightpos1,ro,lightI1,10.0,k_d,k_s);
   
    vec3 lightpos2 = vec3(2.0 * sin(0.37*iTime),2.0 * cos(0.37*iTime),2.0 );
    vec3 lightI2 = vec3(0.5,0.5,0.5);
    col += phongRef(pos,lightpos2,ro,lightI2,10.0,k_d,k_s);
    
	return col;
}

void mainImage( out vec4 fragColor, in vec2 fragCoord )
{
    vec3 ro = vec3(0.0,0.0,5.0);
    vec3 rd = rayDir(45.0,iResolution.xy,fragCoord);
    
    float t = rayCast(ro,rd);
  
    vec3 col = vec3(0.0);
    if(t>MAX_DIST-EPSILON)
    {	
        col = vec3(0.0);
    }
    else
    {
    	vec3 pos = ro + t*rd;
        vec3 nor = calcNormal(pos);
        
        vec3 k_a = vec3(0.2,0.2,0.2);
        vec3 k_d = vec3(0.7,0.2,0.2);
        vec3 k_s = vec3(1.0,1.0,1.0);
        
        col = phongIllu(k_d,k_s,k_a,pos,ro);
    }
    
    fragColor = vec4(col,1.0);
}