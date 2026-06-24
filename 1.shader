Shader "Custom/UnityFunctions1"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Color ("Color", Color) = (1,1,1,1)
        _Value ("Value", Float) = 0.5
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float3 worldPos : TEXCOORD2;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float4 _Color;
            float _Value;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Math Functions
                float absVal = abs(-_Value);
                float signVal = sign(_Value - 0.5);
                float floorVal = floor(_Value * 10.0);
                float ceilVal = ceil(_Value * 10.0);
                float fractVal = frac(_Value * 10.0);
                float roundVal = round(_Value * 10.0);
                float truncVal = trunc(_Value * 10.0);
                float minVal = min(_Value, 0.7);
                float maxVal = max(_Value, 0.3);
                float clampVal = clamp(_Value, 0.2, 0.8);
                float lerpVal = lerp(0.0, 1.0, _Value);
                float stepVal = step(0.5, _Value);
                float smoothstepVal = smoothstep(0.3, 0.7, _Value);
                
                // Trigonometric Functions
                float sinVal = sin(_Value * 3.14159);
                float cosVal = cos(_Value * 3.14159);
                float tanVal = tan(_Value * 0.785398);
                float asinVal = asin(clamp(_Value, -1.0, 1.0));
                float acosVal = acos(clamp(_Value, -1.0, 1.0));
                float atanVal = atan(_Value);
                float atan2Val = atan(_Value, 0.5);
                
                // Exponential & Logarithmic
                float powVal = pow(_Value, 2.0);
                float expVal = exp(_Value);
                float exp2Val = exp2(_Value);
                float logVal = log(max(_Value, 0.001));
                float log2Val = log2(max(_Value, 0.001));
                float log10Val = log10(max(_Value, 0.001));
                float sqrtVal = sqrt(max(_Value, 0.0));
                float rsqrtVal = rsqrt(max(_Value, 0.001));
                
                // Vector Functions
                float3 normalNorm = normalize(i.normal);
                float dotVal = dot(normalNorm, float3(1,0,0));
                float3 crossVal = cross(normalNorm, float3(0,1,0));
                float lenVal = length(normalNorm);
                float distVal = distance(i.worldPos, float3(0,0,0));
                
                // Sampling & Texture
                fixed4 tex = tex2D(_MainTex, i.uv);
                
                // Combine results
                float result = absVal + signVal + floorVal * 0.1 + ceilVal * 0.1 + fractVal + 
                              roundVal * 0.1 + truncVal * 0.1 + minVal + maxVal + clampVal + 
                              lerpVal + stepVal + smoothstepVal + sinVal * 0.5 + cosVal * 0.5 + 
                              tanVal * 0.1 + asinVal * 0.3 + acosVal * 0.3 + atanVal * 0.3 + 
                              atan2Val * 0.3 + powVal + expVal * 0.1 + exp2Val * 0.1 + 
                              logVal * 0.3 + log2Val * 0.3 + log10Val * 0.3 + sqrtVal + 
                              rsqrtVal * 0.1 + dotVal + lenVal * 0.3 + distVal * 0.1;
                
                fixed4 finalColor = tex * _Color * frac(result * 0.1);
                return finalColor;
            }
            ENDCG
        }
    }
}
