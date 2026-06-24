Shader "Custom/UnityFunctions4"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _Parallax ("Height Scale", Float) = 0.1
        _Smoothness ("Smoothness", Range(0,1)) = 0.5
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
            #pragma multi_compile_fwdbase nolightmap nodirlightmap nodynlightmap novertexlight

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 tspace0 : TEXCOORD1;
                float3 tspace1 : TEXCOORD2;
                float3 tspace2 : TEXCOORD3;
                float3 worldPos : TEXCOORD4;
                float4 screenUV : TEXCOORD5;
            };

            sampler2D _MainTex;
            sampler2D _NormalMap;
            float4 _MainTex_ST;
            float _Parallax;
            float _Smoothness;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                float3 wNormal = UnityObjectToWorldNormal(v.normal);
                float3 wTangent = UnityObjectToWorldDir(v.tangent.xyz);
                float3 wBitangent = cross(wNormal, wTangent) * v.tangent.w;
                
                o.tspace0 = float3(wTangent.x, wBitangent.x, wNormal.x);
                o.tspace1 = float3(wTangent.y, wBitangent.y, wNormal.y);
                o.tspace2 = float3(wTangent.z, wBitangent.z, wNormal.z);
                
                o.worldPos = mul(unity_ObjectToWorld, v.vertex).xyz;
                o.screenUV = ComputeScreenPos(o.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Lighting & Shadows (requires #pragma multi_compile_fwdbase)
                #ifdef UNITY_PASS_FORWARDBASE
                    float3 worldLightDir = normalize(_WorldSpaceLightPos0.xyz);
                    float3 atten = LIGHT_ATTENUATION(i);
                #else
                    float3 worldLightDir = normalize(float3(1, 1, 1));
                    float3 atten = float3(1, 1, 1);
                #endif
                
                // Screen space UV operations
                float2 screenUV = i.screenUV.xy / i.screenUV.w;
                
                // Parallax Mapping
                float3 viewDir = normalize(_WorldSpaceCameraPos - i.worldPos);
                float3 tspaceViewDir;
                tspaceViewDir.x = dot(viewDir, i.tspace0);
                tspaceViewDir.y = dot(viewDir, i.tspace1);
                tspaceViewDir.z = dot(viewDir, i.tspace2);
                
                float height = tex2D(_NormalMap, i.uv).a;
                float2 parallaxMapping = i.uv - tspaceViewDir.xy * (height - 0.5) * _Parallax;
                
                // Normal mapping with parallax
                float3 tnorm = tex2D(_NormalMap, parallaxMapping).rgb * 2.0 - 1.0;
                float3 worldNormal;
                worldNormal.x = dot(i.tspace0, tnorm);
                worldNormal.y = dot(i.tspace1, tnorm);
                worldNormal.z = dot(i.tspace2, tnorm);
                worldNormal = normalize(worldNormal);
                
                // Lighting calculations
                float ndotl = max(0.0, dot(worldNormal, worldLightDir));
                float3 halfDir = normalize(worldLightDir + viewDir);
                float ndoth = max(0.0, dot(worldNormal, halfDir));
                float spec = pow(ndoth, 1.0 / _Smoothness);
                
                // Ambient lighting
                float3 ambientLight = ShadeSH9(float4(worldNormal, 1.0));
                
                // Distance attenuation
                float dist = distance(i.worldPos, _WorldSpaceCameraPos);
                float distAtten = 1.0 / (1.0 + dist * dist * 0.01);
                
                // Linear color space conversions
                float3 linearCol = pow(tex2D(_MainTex, parallaxMapping).rgb, 2.2);
                
                // Final lighting
                float3 finalLight = linearCol * (ndotl * atten + ambientLight) + spec * atten;
                
                // Gamma correction for output
                float3 gammaCorrect = pow(finalLight, 1.0 / 2.2);
                
                // Screen space effects
                float2 screenDistortion = sin(screenUV * 10.0 + _Time.y) * 0.01;
                float3 distortedSample = tex2D(_MainTex, screenUV + screenDistortion).rgb;
                
                // Additional utility functions
                float3 toneMapping = finalLight / (finalLight + float3(1, 1, 1));
                
                // Combine all effects
                fixed4 finalColor = fixed4(gammaCorrect * distAtten, 1.0);
                finalColor += fixed4(toneMapping * 0.1, 0.0);
                
                return finalColor;
            }
            ENDCG
        }
    }
    Fallback "Diffuse"
}
