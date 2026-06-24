// Shader: Complete Blend Mode - Additive
// Demonstrates: Blend One One
// Effect: Additive color blending for light effects
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "Blend/Additive_One_One"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _IntensityValue ("Intensity Value", Range(0.0, 2.0)) = 1.0
        _EmissionStrength ("Emission Strength", Float) = 1.0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent+100"
            "LightMode" = "ForwardBase"
            "IgnoreProjector" = "True"
        }
        
        LOD 200
        
        Pass
        {
            Name "ADDITIVE_BLEND_PASS"
            
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            
            Blend One One
            BlendOp Add
            ColorMask RGBA
            ZWrite Off
            ZTest LEqual
            Cull Back
            Offset 0, 0
            
            CGPROGRAM
            
            #pragma vertex VertexShaderAdditive
            #pragma fragment FragmentShaderAdditive
            #pragma target 3.0
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _MainColor;
            float _IntensityValue;
            float _EmissionStrength;
            
            struct VertexInput
            {
                float4 VertexPosition : POSITION;
                float3 VertexNormal : NORMAL;
                float2 VertexTexCoord0 : TEXCOORD0;
                float4 VertexColor : COLOR;
            };
            
            struct VertexOutput
            {
                float4 ClipPosition : SV_POSITION;
                float2 TextureCoordinate0 : TEXCOORD0;
                float3 WorldPosition : TEXCOORD1;
                float4 VertexColor : TEXCOORD2;
            };
            
            VertexOutput VertexShaderAdditive(VertexInput Input)
            {
                VertexOutput Output;
                
                float4 WorldPosition = mul(unity_ObjectToWorld, Input.VertexPosition);
                Output.ClipPosition = mul(UNITY_MATRIX_VP, WorldPosition);
                Output.WorldPosition = WorldPosition.xyz;
                Output.TextureCoordinate0 = Input.VertexTexCoord0 * _MainTexture_ST.xy + _MainTexture_ST.zw;
                Output.VertexColor = Input.VertexColor;
                
                return Output;
            }
            
            fixed4 FragmentShaderAdditive(VertexOutput Input) : SV_Target
            {
                fixed4 SampledTexture = tex2D(_MainTexture, Input.TextureCoordinate0);
                fixed4 FinalColor = SampledTexture * _MainColor * _IntensityValue * _EmissionStrength;
                FinalColor.a = SampledTexture.a * _IntensityValue;
                
                return FinalColor;
            }
            
            ENDCG
        }
    }
    
    Fallback "Transparent/VertexLit"
}
