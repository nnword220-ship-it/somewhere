Shader "Keywords/LOD"
{
    SubShader
    {
        LOD 100
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return pos; }
            fixed4 frag() : SV_Target { return fixed4(1,1,0,1); }
            ENDCG
        }
    }
    SubShader
    {
        LOD 200
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return pos; }
            fixed4 frag() : SV_Target { return fixed4(1,0,1,1); }
            ENDCG
        }
    }
}
