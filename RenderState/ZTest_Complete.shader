// Shader: Complete Render State - ZTest
// Demonstrates: ZTest Less, Greater, LEqual, GEqual, Equal, NotEqual, Always, Never
// Effect: Depth comparison functions
// Graphics APIs: DirectX 11, OpenGL 4.5, Vulkan, Metal

Shader "RenderState/ZTest_All_Modes"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1.0, 1.0, 1.0, 1.0)
    }
    
    SubShader
    {
        Tags { "RenderType" = "Opaque" }
        LOD 100
        
        Pass
        {
            Name "ZTEST_LESS"
            ZTest Less
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(1.0, 0.0, 0.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_GREATER"
            ZTest Greater
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(0.0, 1.0, 0.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_LEQUAL"
            ZTest LEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(0.0, 0.0, 1.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_GEQUAL"
            ZTest GEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(1.0, 1.0, 0.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_EQUAL"
            ZTest Equal
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(1.0, 0.0, 1.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_NOTEQUAL"
            ZTest NotEqual
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(0.0, 1.0, 1.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_ALWAYS"
            ZTest Always
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(1.0, 1.0, 1.0, 1.0); }
            ENDCG
        }
        
        Pass
        {
            Name "ZTEST_NEVER"
            ZTest Never
            ZWrite On
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return UnityObjectToClipPos(pos); }
            fixed4 frag() : SV_Target { return fixed4(0.0, 0.0, 0.0, 1.0); }
            ENDCG
        }
    }
    
    Fallback "Diffuse"
}
