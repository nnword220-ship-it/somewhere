// Shader: Complete Blend Mode - Alpha Blending
// Demonstrates: Blend SrcAlpha OneMinusSrcAlpha
// Effect: Standard transparency with pre-multiplied alpha
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "Blend/AlphaBlend_SrcAlpha_OneMinusSrcAlpha"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
        _AlphaValue ("Alpha Value", Range(0.0, 1.0)) = 1.0
        _TextureScale ("Texture Scale", Float) = 1.0
        _TextureOffset ("Texture Offset", Vector) = (0.0, 0.0, 0.0, 0.0)
    }
    
    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "LightMode" = "ForwardBase"
            "IgnoreProjector" = "True"
            "ForceNoShadowCasting" = "False"
            "PreviewType" = "Plane"
            "CanUseSpriteAtlas" = "True"
        }
        
        LOD 200
        
        Pass
        {
            Name "ALPHA_BLEND_PASS"
            
            Tags
            {
                "LightMode" = "ForwardBase"
            }
            
            // Render State Configuration
            Blend SrcAlpha OneMinusSrcAlpha
            BlendOp Add
            ColorMask RGBA
            ZWrite Off
            ZTest LEqual
            Cull Back
            Offset 0, 0
            
            CGPROGRAM
            
            #pragma vertex VertexShaderAlphaBlend
            #pragma fragment FragmentShaderAlphaBlend
            #pragma target 3.0
            #pragma multi_compile_fog
            #pragma multi_compile_instancing
            #pragma instancing_options assumeuniformscaling
            
            #include "UnityCG.cginc"
            
            // Texture and Sampler Declarations
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            
            // Property Declarations
            float4 _MainColor;
            float _AlphaValue;
            float _TextureScale;
            float4 _TextureOffset;
            
            // Built-in Unity Variables
            uniform float4 _Time;
            uniform float4 _SinTime;
            uniform float4 _CosTime;
            uniform float4 _DeltaTime;
            uniform float3 _WorldSpaceCameraPos;
            uniform float4 _ProjectionParams;
            uniform float4 _ScreenParams;
            uniform float4 _ZBufferParams;
            uniform float3 _WorldSpaceLightPos0;
            uniform float4 _LightColor0;
            
            // Input Structure - Vertex Attributes
            struct VertexInput
            {
                float4 VertexPosition : POSITION;
                float3 VertexNormal : NORMAL;
                float4 VertexTangent : TANGENT;
                float2 VertexTexCoord0 : TEXCOORD0;
                float2 VertexTexCoord1 : TEXCOORD1;
                float4 VertexColor : COLOR;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };
            
            // Output Structure - Vertex to Fragment
            struct VertexOutput
            {
                float4 ClipPosition : SV_POSITION;
                float2 TextureCoordinate0 : TEXCOORD0;
                float2 TextureCoordinate1 : TEXCOORD1;
                float3 WorldPosition : TEXCOORD2;
                float3 WorldNormal : TEXCOORD3;
                float3 WorldTangent : TEXCOORD4;
                float3 WorldBitangent : TEXCOORD5;
                float4 VertexColor : TEXCOORD6;
                float4 ScreenPosition : TEXCOORD7;
                UNITY_FOG_COORDS(8)
                UNITY_VERTEX_OUTPUT_STEREO
            };
            
            // Vertex Shader: VertexShaderAlphaBlend
            VertexOutput VertexShaderAlphaBlend(VertexInput Input)
            {
                UNITY_SETUP_INSTANCE_ID(Input);
                
                VertexOutput Output;
                UNITY_INITIALIZE_VERTEX_OUTPUT_STEREO(Output);
                
                // Transform Position to Clip Space
                float4 WorldPosition = mul(unity_ObjectToWorld, Input.VertexPosition);
                float4 ClipPosition = mul(UNITY_MATRIX_VP, WorldPosition);
                Output.ClipPosition = ClipPosition;
                
                // Store World Position
                Output.WorldPosition = WorldPosition.xyz;
                
                // Transform Normal to World Space
                Output.WorldNormal = normalize(mul(Input.VertexNormal, (float3x3)unity_WorldToObject));
                Output.WorldNormal = normalize(mul(unity_ObjectToWorld, float4(Input.VertexNormal, 0.0)).xyz);
                
                // Transform Tangent to World Space
                Output.WorldTangent = normalize(mul((float3x3)unity_ObjectToWorld, Input.VertexTangent.xyz));
                
                // Calculate Bitangent
                Output.WorldBitangent = cross(Output.WorldNormal, Output.WorldTangent) * Input.VertexTangent.w;
                
                // Apply Texture Coordinates with Scale and Offset
                Output.TextureCoordinate0 = Input.VertexTexCoord0 * _MainTexture_ST.xy + _MainTexture_ST.zw;
                Output.TextureCoordinate0 *= _TextureScale;
                Output.TextureCoordinate0 += _TextureOffset.xy;
                
                // Store Secondary Texture Coordinate
                Output.TextureCoordinate1 = Input.VertexTexCoord1;
                
                // Pass Through Vertex Color
                Output.VertexColor = Input.VertexColor;
                
                // Calculate Screen Position
                Output.ScreenPosition = ComputeScreenPos(ClipPosition);
                
                // Calculate Fog Coordinates
                UNITY_TRANSFER_FOG(Output, Output.ClipPosition);
                
                return Output;
            }
            
            // Fragment Shader: FragmentShaderAlphaBlend
            fixed4 FragmentShaderAlphaBlend(VertexOutput Input) : SV_Target
            {
                // Sample Main Texture
                fixed4 SampledTexture = tex2D(_MainTexture, Input.TextureCoordinate0);
                
                // Apply Main Color
                fixed4 ColoredTexture = SampledTexture * _MainColor;
                
                // Apply Alpha Value
                fixed4 FinalColor = ColoredTexture;
                FinalColor.a = ColoredTexture.a * _AlphaValue;
                
                // Apply Fog
                UNITY_APPLY_FOG(Input.fogCoord, FinalColor);
                
                return FinalColor;
            }
            
            ENDCG
        }
    }
    
    Fallback "Transparent/VertexLit"
    CustomEditor "UnityEditor.ShaderGraph.PBRMasterGUI"
}
