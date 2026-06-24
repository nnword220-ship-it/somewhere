Shader "Custom/UnityFunctions3"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _CubeTex ("Cube Texture", Cube) = "" {}
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
                float3 viewDir : TEXCOORD3;
            };

            sampler2D _MainTex;
            samplerCUBE _CubeTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.viewDir = normalize(_WorldSpaceCameraPos.xyz - o.worldPos);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Texture Sampling
                fixed4 col = tex2D(_MainTex, i.uv);
                fixed4 cubeSample = texCUBE(_CubeTex, i.normal);
                
                // Parallax/LOD sampling
                fixed4 texLod = tex2Dlod(_MainTex, float4(i.uv, 0, 2.0));
                fixed4 texProj = tex2Dproj(_MainTex, float4(i.uv, 1.0, 1.0));
                
                // Gradient-based sampling (requires derivatives)
                fixed4 texGrad = tex2Dgrad(_MainTex, i.uv, ddx(i.uv), ddy(i.uv));
                
                // Color operations
                float3 rgbCol = col.rgb;
                float grayCol = dot(rgbCol, float3(0.299, 0.587, 0.114));
                
                // Saturation adjustment
                float3 desaturated = lerp(grayCol.xxx, rgbCol, 0.5);
                
                // Gamma correction
                float3 gamma22 = pow(rgbCol, float3(2.2, 2.2, 2.2));
                float3 gamma122 = pow(rgbCol, float3(1.0/2.2, 1.0/2.2, 1.0/2.2));
                
                // Normal-based effects
                float3 normal = normalize(i.normal);
                float3 viewDir = normalize(i.viewDir);
                float3 halfVec = normalize(normal + viewDir);
                float fresnel = pow(1.0 - dot(viewDir, normal), 5.0);
                
                // Reflection/Refraction vectors
                float3 reflectVec = reflect(-viewDir, normal);
                float3 refractVec = refract(-viewDir, normal, 1.0 / 1.5);
                
                // Face normals
                float3 faceNorm = faceforward(normal, -viewDir, normal);
                
                // Cube map sampling with reflection
                fixed4 reflectionSample = texCUBE(_CubeTex, reflectVec);
                
                // Combine
                float result = grayCol + length(desaturated) * 0.3 + fresnel +
                              length(reflectVec) * 0.1 + length(refractVec) * 0.1;
                
                fixed4 finalColor = col * fixed4(gamma22, 1.0) + 
                                   reflectionSample * fresnel + 
                                   fixed4(frac(result), frac(result * 0.5), frac(result * 0.7), 1.0) * 0.2;
                
                return finalColor;
            }
            ENDCG
        }
    }
}
