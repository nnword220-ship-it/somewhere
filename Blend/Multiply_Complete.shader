// Shader: Complete Blend Mode - Multiply
// Demonstrates: Blend DstColor Zero
// Effect: Multiplicative color blending for darkening
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "Blend/Multiply_DstColor_Zero"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _MultiplyIntensity ("Multiply Intensity", Range(0.0, 1.0)) = 1.0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Opaque"
            "Queue" = "Geometry+1"
        }
        
        LOD 200
        
        Pass
        {
            Name "MULTIPLY_BLEND_PASS"
            
            Blend DstColor Zero
            BlendOp Add
            ColorMask RGBA
            ZWrite On
            ZTest LEqual
            Cull Back
            Offset 0, 0
            
            CGPROGRAM
            
            #pragma vertex VertexShaderMultiply
            #pragma fragment FragmentShaderMultiply
            #pragma target 3.0
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _MainColor;
            float _MultiplyIntensity;
            
            struct VertexInput
            {
                float4 VertexPosition : POSITION;
                float2 VertexTexCoord0 : TEXCOORD0;
            };
            
            struct VertexOutput
            {
                float4 ClipPosition : SV_POSITION;
                float2 TextureCoordinate0 : TEXCOORD0;
            };
            
            VertexOutput VertexShaderMultiply(VertexInput Input)
            {
                VertexOutput Output;
                Output.ClipPosition = UnityObjectToClipPos(Input.VertexPosition);
                Output.TextureCoordinate0 = Input.VertexTexCoord0 * _MainTexture_ST.xy + _MainTexture_ST.zw;
                return Output;
            }
            
            fixed4 FragmentShaderMultiply(VertexOutput Input) : SV_Target
            {
                fixed4 SampledTexture = tex2D(_MainTexture, Input.TextureCoordinate0);
                fixed4 FinalColor = SampledTexture * _MainColor * _MultiplyIntensity;
                return FinalColor;
            }
            
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}
