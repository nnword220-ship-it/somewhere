// Shader: Complete Blend Mode - Screen
// Demonstrates: Blend OneMinusDstColor One
// Effect: Screen blend mode for light effects
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "Blend/Screen_OneMinusDstColor_One"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _ScreenColor ("Screen Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _ScreenIntensity ("Screen Intensity", Range(0.0, 2.0)) = 1.0
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent+50"
        }
        
        LOD 200
        
        Pass
        {
            Name "SCREEN_BLEND_PASS"
            
            Blend OneMinusDstColor One
            BlendOp Add
            ColorMask RGBA
            ZWrite Off
            ZTest LEqual
            Cull Back
            
            CGPROGRAM
            
            #pragma vertex VertexShaderScreen
            #pragma fragment FragmentShaderScreen
            #pragma target 3.0
            
            #include "UnityCG.cginc"
            
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _ScreenColor;
            float _ScreenIntensity;
            
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
            
            VertexOutput VertexShaderScreen(VertexInput Input)
            {
                VertexOutput Output;
                Output.ClipPosition = UnityObjectToClipPos(Input.VertexPosition);
                Output.TextureCoordinate0 = Input.VertexTexCoord0 * _MainTexture_ST.xy + _MainTexture_ST.zw;
                return Output;
            }
            
            fixed4 FragmentShaderScreen(VertexOutput Input) : SV_Target
            {
                fixed4 SampledTexture = tex2D(_MainTexture, Input.TextureCoordinate0);
                fixed4 FinalColor = SampledTexture * _ScreenColor * _ScreenIntensity;
                return FinalColor;
            }
            
            ENDCG
        }
    }
    
    Fallback "Transparent/VertexLit"
}
