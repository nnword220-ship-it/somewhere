Shader "Keywords/Properties"
{
    Properties
    {
        _MainColor ("Main Color", Color) = (1,1,1,1)
        _MainFloat ("Main Float", Float) = 1.0
        _MainInt ("Main Int", Int) = 1
        _MainTexture ("Main Texture", 2D) = "white" {}
        _MainRange ("Main Range", Range(0,1)) = 0.5
    }
    SubShader
    {
        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            float4 vert(float4 pos : POSITION) : SV_POSITION { return pos; }
            fixed4 frag() : SV_Target { return fixed4(1,0,0,1); }
            ENDCG
        }
    }
}
