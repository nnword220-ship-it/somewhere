Shader "Keywords/Tags"
{
    SubShader
    {
        Tags { "RenderType"="Opaque" "Queue"="Geometry" "LightMode"="ForwardBase" "IgnoreProjector"="False" "ForceNoShadowCasting"="False" }
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return pos; }
            fixed4 frag() : SV_Target { return fixed4(0,0,1,1); }
            ENDCG
        }
    }
}
