// Shader: Complete Render State - ZWrite
// Demonstrates: ZWrite On / ZWrite Off
// Effect: Control of depth buffer writing
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "RenderState/ZWrite_On_Off"
{
    Properties
    {
        _MainTexture ("Main Texture", 2D) = "white" {}
        _MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        
        // Pass with ZWrite On
        Pass
        {
            Name "ZWRITE_ON_PASS"
            
            ZWrite On
            ZTest LEqual
            ColorMask RGBA
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _MainColor;
            
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };
            
            v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv * _MainTexture_ST.xy + _MainTexture_ST.zw;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTexture, i.uv);
                return texColor * _MainColor;
            }
            ENDCG
        }
    }
    
    SubShader
    {
        Tags { "RenderType" = "Transparent" }
        LOD 100
        
        // Pass with ZWrite Off
        Pass
        {
            Name "ZWRITE_OFF_PASS"
            
            ZWrite Off
            ZTest LEqual
            Blend SrcAlpha OneMinusSrcAlpha
            ColorMask RGBA
            Cull Back
            
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #include "UnityCG.cginc"
            
            sampler2D _MainTexture;
            float4 _MainTexture_ST;
            float4 _MainColor;
            
            struct v2f { float4 pos : SV_POSITION; float2 uv : TEXCOORD0; };
            
            v2f vert(float4 vertex : POSITION, float2 uv : TEXCOORD0)
            {
                v2f o;
                o.pos = UnityObjectToClipPos(vertex);
                o.uv = uv * _MainTexture_ST.xy + _MainTexture_ST.zw;
                return o;
            }
            
            fixed4 frag(v2f i) : SV_Target
            {
                fixed4 texColor = tex2D(_MainTexture, i.uv);
                return texColor * _MainColor;
            }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}
