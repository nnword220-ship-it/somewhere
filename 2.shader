Shader "Custom/UnityFunctions2"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NormalMap ("Normal Map", 2D) = "bump" {}
        _Time ("Time", Float) = 0
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
                float4 tangent : TANGENT;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                float3 normal : TEXCOORD1;
                float4 tangent : TEXCOORD2;
                float3 bitangent : TEXCOORD3;
                float4 screenPos : TEXCOORD4;
            };

            sampler2D _MainTex;
            sampler2D _NormalMap;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                
                // Normal space transforms
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.tangent.xyz = UnityObjectToWorldDir(v.tangent.xyz);
                o.tangent.w = v.tangent.w;
                o.bitangent = cross(o.normal, o.tangent.xyz) * v.tangent.w;
                
                o.screenPos = ComputeScreenPos(o.vertex);
                
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // Bit Functions
                uint u1 = asuint(0.5);
                uint u2 = asuint(0.3);
                float f1 = asfloat(u1);
                float f2 = asfloat(u2);
                
                // Rounding variants
                float roundVal = round(3.7);
                float truncVal = trunc(3.7);
                float floorVal = floor(3.7);
                float ceilVal = ceil(3.7);
                
                // Modulo operations
                float modVal = fmod(3.7, 1.5);
                float remVal = remainder(3.7, 1.5);
                
                // Advanced Math
                float cbrtVal = cbrt(0.125);
                float hypotVal = hypot(3.0, 4.0);
                float copysignVal = copysign(5.0, -1.0);
                
                // Float classification
                float isnanVal = isnan(0.0 / 0.0) ? 1.0 : 0.0;
                float isinfiniteVal = isinfinite(1.0 / 0.0) ? 1.0 : 0.0;
                float isfiniteVal = isfinite(5.0) ? 1.0 : 0.0;
                float isnormalVal = isnormal(0.0001) ? 1.0 : 0.0;
                
                // Matrix Functions
                float4x4 m1 = float4x4(
                    1, 0, 0, 0,
                    0, 1, 0, 0,
                    0, 0, 1, 0,
                    0, 0, 0, 1
                );
                float4x4 m2 = float4x4(
                    2, 0, 0, 0,
                    0, 2, 0, 0,
                    0, 0, 2, 0,
                    0, 0, 0, 1
                );
                float4x4 matMult = mul(m1, m2);
                float matDeterminant = determinant(m1);
                
                // Transpose
                float3x3 m3x3 = float3x3(
                    1, 2, 3,
                    4, 5, 6,
                    7, 8, 9
                );
                float3x3 transposed = transpose(m3x3);
                
                // Normal mapping
                float3 normal = tex2D(_NormalMap, i.uv).rgb * 2.0 - 1.0;
                float3x3 tbn = float3x3(i.tangent.xyz, i.bitangent, i.normal);
                float3 worldNormal = mul(normal, tbn);
                
                // Lighting calculations
                float3 lightDir = normalize(float3(1, 1, 1));
                float ndotl = dot(worldNormal, lightDir);
                
                float result = modVal + remVal + cbrtVal + hypotVal * 0.1 + copysignVal * 0.1 +
                              isnanVal + isinfiniteVal + isfiniteVal + isnormalVal +
                              matDeterminant * 0.1 + length(matMult[0].xyz) * 0.01 +
                              length(transposed[0]) * 0.01 + ndotl * 0.5;
                
                fixed4 finalColor = fixed4(frac(result * 0.5), frac(result * 0.3), frac(result * 0.7), 1.0);
                return finalColor;
            }
            ENDCG
        }
    }
}
