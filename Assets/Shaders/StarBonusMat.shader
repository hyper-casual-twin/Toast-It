﻿Shader "Custom/StarBonusMat"
{
    Properties
    {
        _Color ("Color", Color) = (1,1,1,1)
        _MainTex ("Albedo (RGB)", 2D) = "white" {}
        _Glossiness("Smoothness", Range(0,1)) = 0.5
        _Metallic("Metallic", Range(0,1)) = 0.0
        _Range("BonusRange", Range(0,1.57)) = 0.5
        _GradientScale("GradientScale",Range(0.0,10.0))=3.0
    }
    SubShader
    {
         Tags {"Queue" = "Transparent" "RenderType" = "Transparent" }
        LOD 200

        CGPROGRAM
        // Physically based Standard lighting model, and enable shadows on all light types
        #pragma surface surf Standard fullforwardshadows alpha:fade

        // Use shader model 3.0 target, to get nicer looking lighting
        #pragma target 3.0

        sampler2D _MainTex;

        struct Input
        {
            float2 uv_MainTex;
        };

        half _Glossiness;
        half _Metallic;
        fixed4 _Color;
        half _Range;
        half _GradientScale;

        // Add instancing support for this shader. You need to check 'Enable Instancing' on materials that use the shader.
        // See https://docs.unity3d.com/Manual/GPUInstancing.html for more information about instancing.
        // #pragma instancing_options assumeuniformscaling
        UNITY_INSTANCING_BUFFER_START(Props)
            // put more per-instance properties here
        UNITY_INSTANCING_BUFFER_END(Props)

        void surf (Input IN, inout SurfaceOutputStandard o)
        {
            // Albedo comes from a texture tinted by color
            float alpha = atan2(IN.uv_MainTex.y - 0.5, IN.uv_MainTex.x - 0.5) + 0.9825;
            if (abs(alpha) < _Range)
            {
                fixed4 c = tex2D(_MainTex, IN.uv_MainTex)* _Color;
                o.Albedo = c.rgb;
                // Metallic and smoothness come from slider variables
                o.Metallic = _Metallic;
                o.Smoothness = _Glossiness;
                if (tex2D(_MainTex, IN.uv_MainTex).a > 0.5)
                {
                    o.Alpha = 1.0;
                }
                else 
                {
                    o.Alpha = pow(pow(pow(IN.uv_MainTex.y*2.0 - 1.0 ,2.0)+pow(IN.uv_MainTex.x*2.0 - 1.0,2.0), 0.5), _GradientScale);
                }
            }
            else { discard; }
        }
        ENDCG
    }
    FallBack "Diffuse"
}
