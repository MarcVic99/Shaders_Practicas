Shader "Shader Graphs/Water"
{
    Properties
    {
        _UVScale("UVScale", Float) = 2
        _Noise_Speed("Noise Speed", Float) = 0.2
        _First_Noise_Size("First Noise Size", Float) = 6
        _Second_Noise_Size("Second Noise Size", Float) = 4
        _Foam_Distortion_Intensity("Foam Distortion Intensity", Float) = 0.5
        _Water_Color("Water Color", Color) = (0, 0.8104148, 1, 1)
        _Foam_Color("Foam Color", Color) = (1, 1, 1, 1)
        _Water_Opacity("Water Opacity", Float) = 0.4
        _Foam_Size("Foam Size", Range(0.02, 0.6)) = 0.2
        _Displacment_Intensity("Displacment Intensity", Float) = 1
        _Normal_Scale("Normal Scale", Float) = 0.2
        _Normal_Speed("Normal Speed", Float) = 0.1
        _Shore_Foam_Distance("Shore Foam Distance", Float) = 3
        [NonModifiableTextureData][Normal][NoScaleOffset]_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D("Texture2D", 2D) = "bump" {}
        [NonModifiableTextureData][Normal][NoScaleOffset]_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D("Texture2D", 2D) = "bump" {}
        [HideInInspector]_QueueOffset("_QueueOffset", Float) = 0
        [HideInInspector]_QueueControl("_QueueControl", Float) = -1
        [HideInInspector][NoScaleOffset]unity_Lightmaps("unity_Lightmaps", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_LightmapsInd("unity_LightmapsInd", 2DArray) = "" {}
        [HideInInspector][NoScaleOffset]unity_ShadowMasks("unity_ShadowMasks", 2DArray) = "" {}
    }
    SubShader
    {
        Tags
        {
            "RenderPipeline"="UniversalPipeline"
            "RenderType"="Transparent"
            "UniversalMaterialType" = "Lit"
            "Queue"="Transparent"
            "DisableBatching"="False"
            "ShaderGraphShader"="true"
            "ShaderGraphTargetId"="UniversalLitSubTarget"
        }
        Pass
        {
            Name "Universal Forward"
            Tags
            {
                "LightMode" = "UniversalForward"
            }
        
        // Render State
        Cull Back
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_fragment _ _SCREEN_SPACE_OCCLUSION
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile _ _ADDITIONAL_LIGHTS_VERTEX _ADDITIONAL_LIGHTS
        #pragma multi_compile_fragment _ _ADDITIONAL_LIGHT_SHADOWS
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_ATLAS
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _LIGHT_LAYERS
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile_fragment _ _LIGHT_COOKIES
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        #pragma multi_compile _ EVALUATE_SH_MIXED EVALUATE_SH_VERTEX
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_FORWARD
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4 = _Water_Color;
            float4 _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4 = _Foam_Color;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float4 _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4;
            Unity_Lerp_float4(_Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4, _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4, (_Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float.xxxx), _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4);
            float4 _UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4 = IN.uv0;
            float _Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float = _Normal_Scale;
            float4 _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4, (_Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float.xxxx), _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4);
            float _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float = _Normal_Speed;
            float _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float, _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float4 _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4;
            Unity_Add_float4(_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4, (_Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float.xxxx), _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4);
            float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).GetTransformedUV((_Add_42122df8442448e3969f8067603adadb_Out_2_Vector4.xy)) );
            _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4);
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_R_4_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.r;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_G_5_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.g;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_B_6_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.b;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_A_7_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.a;
            float2 _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2 = float2(float(0), _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float2 _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2;
            Unity_Add_float2((_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4.xy), _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2, _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2);
            float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).GetTransformedUV(_Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2) );
            _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4);
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_R_4_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.r;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_G_5_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.g;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_B_6_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.b;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_A_7_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.a;
            float4 _Add_0018298b645b4497943029777bc50708_Out_2_Vector4;
            Unity_Add_float4(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4, _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4, _Add_0018298b645b4497943029777bc50708_Out_2_Vector4);
            float4 _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4;
            Unity_Normalize_float4(_Add_0018298b645b4497943029777bc50708_Out_2_Vector4, _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.BaseColor = (_Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4.xyz);
            surface.NormalTS = (_Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRForwardPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "GBuffer"
            Tags
            {
                "LightMode" = "UniversalGBuffer"
            }
        
        // Render State
        Cull Back
        Blend One OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 4.5
        #pragma exclude_renderers gles3 glcore
        #pragma multi_compile_instancing
        #pragma instancing_options renderinglayer
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile _ LIGHTMAP_ON
        #pragma multi_compile _ DYNAMICLIGHTMAP_ON
        #pragma multi_compile _ DIRLIGHTMAP_COMBINED
        #pragma multi_compile _ USE_LEGACY_LIGHTMAPS
        #pragma multi_compile _ LIGHTMAP_BICUBIC_SAMPLING
        #pragma multi_compile _ _MAIN_LIGHT_SHADOWS _MAIN_LIGHT_SHADOWS_CASCADE _MAIN_LIGHT_SHADOWS_SCREEN
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BLENDING
        #pragma multi_compile_fragment _ _REFLECTION_PROBE_BOX_PROJECTION
        #pragma multi_compile_fragment _ _SHADOWS_SOFT _SHADOWS_SOFT_LOW _SHADOWS_SOFT_MEDIUM _SHADOWS_SOFT_HIGH
        #pragma multi_compile _ LIGHTMAP_SHADOW_MIXING
        #pragma multi_compile _ SHADOWS_SHADOWMASK
        #pragma multi_compile _ _MIXED_LIGHTING_SUBTRACTIVE
        #pragma multi_compile_fragment _ _DBUFFER_MRT1 _DBUFFER_MRT2 _DBUFFER_MRT3
        #pragma multi_compile_fragment _ _GBUFFER_NORMALS_OCT
        #pragma multi_compile_fragment _ _RENDER_PASS_ENABLED
        #pragma multi_compile_fragment _ DEBUG_DISPLAY
        #pragma multi_compile _ _CLUSTER_LIGHT_LOOP
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_FOG_AND_VERTEX_LIGHT
        #define VARYINGS_NEED_SHADOW_COORD
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_GBUFFER
        #define _FOG_FRAGMENT 1
        #define _SURFACE_TYPE_TRANSPARENT 1
        #define _ALPHAPREMULTIPLY_ON 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Fog.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ProbeVolumeVariants.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Shadows.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DBuffer.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion;
            #endif
             float4 fogFactorAndVertexLight;
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord;
            #endif
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
            #if defined(LIGHTMAP_ON)
             float2 staticLightmapUV : INTERP0;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
             float2 dynamicLightmapUV : INTERP1;
            #endif
            #if !defined(LIGHTMAP_ON)
             float3 sh : INTERP2;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
             float4 probeOcclusion : INTERP3;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
             float4 shadowCoord : INTERP4;
            #endif
             float4 tangentWS : INTERP5;
             float4 texCoord0 : INTERP6;
             float4 fogFactorAndVertexLight : INTERP7;
             float3 positionWS : INTERP8;
             float3 normalWS : INTERP9;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.fogFactorAndVertexLight.xyzw = input.fogFactorAndVertexLight;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            #if defined(LIGHTMAP_ON)
            output.staticLightmapUV = input.staticLightmapUV;
            #endif
            #if defined(DYNAMICLIGHTMAP_ON)
            output.dynamicLightmapUV = input.dynamicLightmapUV;
            #endif
            #if !defined(LIGHTMAP_ON)
            output.sh = input.sh;
            #endif
            #if defined(USE_APV_PROBE_OCCLUSION)
            output.probeOcclusion = input.probeOcclusion;
            #endif
            #if defined(REQUIRES_VERTEX_SHADOW_COORD_INTERPOLATOR)
            output.shadowCoord = input.shadowCoord;
            #endif
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.fogFactorAndVertexLight = input.fogFactorAndVertexLight.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 NormalTS;
            float3 Emission;
            float Metallic;
            float Smoothness;
            float Occlusion;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4 = _Water_Color;
            float4 _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4 = _Foam_Color;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float4 _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4;
            Unity_Lerp_float4(_Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4, _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4, (_Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float.xxxx), _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4);
            float4 _UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4 = IN.uv0;
            float _Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float = _Normal_Scale;
            float4 _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4, (_Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float.xxxx), _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4);
            float _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float = _Normal_Speed;
            float _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float, _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float4 _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4;
            Unity_Add_float4(_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4, (_Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float.xxxx), _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4);
            float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).GetTransformedUV((_Add_42122df8442448e3969f8067603adadb_Out_2_Vector4.xy)) );
            _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4);
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_R_4_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.r;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_G_5_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.g;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_B_6_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.b;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_A_7_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.a;
            float2 _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2 = float2(float(0), _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float2 _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2;
            Unity_Add_float2((_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4.xy), _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2, _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2);
            float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).GetTransformedUV(_Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2) );
            _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4);
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_R_4_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.r;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_G_5_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.g;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_B_6_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.b;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_A_7_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.a;
            float4 _Add_0018298b645b4497943029777bc50708_Out_2_Vector4;
            Unity_Add_float4(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4, _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4, _Add_0018298b645b4497943029777bc50708_Out_2_Vector4);
            float4 _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4;
            Unity_Normalize_float4(_Add_0018298b645b4497943029777bc50708_Out_2_Vector4, _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.BaseColor = (_Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4.xyz);
            surface.NormalTS = (_Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Metallic = float(0);
            surface.Smoothness = float(0.5);
            surface.Occlusion = float(1);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/GBufferOutput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBRGBufferPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ShadowCaster"
            Tags
            {
                "LightMode" = "ShadowCaster"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask 0
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma multi_compile_vertex _ _CASTING_PUNCTUAL_LIGHT_SHADOW
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_SHADOWCASTER
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
             float3 normalWS : INTERP2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShadowCasterPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "MotionVectors"
            Tags
            {
                "LightMode" = "MotionVectors"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        ColorMask RG
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 3.5
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_MOTION_VECTORS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/MotionVectorPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "DepthNormals"
            Tags
            {
                "LightMode" = "DepthNormals"
            }
        
        // Render State
        Cull Back
        ZTest LEqual
        ZWrite On
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma multi_compile_instancing
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_NORMAL_WS
        #define VARYINGS_NEED_TANGENT_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHNORMALS
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/RenderingLayers.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float3 normalWS;
             float4 tangentWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 TangentSpaceNormal;
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 tangentWS : INTERP0;
             float4 texCoord0 : INTERP1;
             float3 positionWS : INTERP2;
             float3 normalWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.tangentWS.xyzw = input.tangentWS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            output.normalWS.xyz = input.normalWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.tangentWS = input.tangentWS.xyzw;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            output.normalWS = input.normalWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A + B;
        }
        
        void Unity_Normalize_float4(float4 In, out float4 Out)
        {
            Out = normalize(In);
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 NormalTS;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4 = IN.uv0;
            float _Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float = _Normal_Scale;
            float4 _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_5df7a44d8bea4a8397ff2f4b0dfbd55c_Out_0_Vector4, (_Property_76fa7f61a1294228bf0b89b4aa6d41df_Out_0_Float.xxxx), _Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4);
            float _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float = _Normal_Speed;
            float _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_dfbf9d7ac02b4cdba5c65f7b89c8bb6d_Out_0_Float, _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float4 _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4;
            Unity_Add_float4(_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4, (_Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float.xxxx), _Add_42122df8442448e3969f8067603adadb_Out_2_Vector4);
            float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D).GetTransformedUV((_Add_42122df8442448e3969f8067603adadb_Out_2_Vector4.xy)) );
            _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4);
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_R_4_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.r;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_G_5_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.g;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_B_6_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.b;
            float _SampleTexture2D_27fa16c9565e4520be268a346658409e_A_7_Float = _SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4.a;
            float2 _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2 = float2(float(0), _Multiply_93b1561f0c914ebdb88762d80708f570_Out_2_Float);
            float2 _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2;
            Unity_Add_float2((_Multiply_e5c3bc70b4b94088b5e8cf4c5ff62018_Out_2_Vector4.xy), _Vector2_c3ad5fa17e2b4cb3b22459b20959ab49_Out_0_Vector2, _Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2);
            float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4 = SAMPLE_TEXTURE2D(UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).tex, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).samplerstate, UnityBuildTexture2DStructNoScale(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D).GetTransformedUV(_Add_def75e4536434091bd140af4fbaac700_Out_2_Vector2) );
            _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.rgb = UnpackNormal(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4);
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_R_4_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.r;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_G_5_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.g;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_B_6_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.b;
            float _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_A_7_Float = _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4.a;
            float4 _Add_0018298b645b4497943029777bc50708_Out_2_Vector4;
            Unity_Add_float4(_SampleTexture2D_27fa16c9565e4520be268a346658409e_RGBA_0_Vector4, _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_RGBA_0_Vector4, _Add_0018298b645b4497943029777bc50708_Out_2_Vector4);
            float4 _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4;
            Unity_Normalize_float4(_Add_0018298b645b4497943029777bc50708_Out_2_Vector4, _Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.NormalTS = (_Normalize_75f59556dc814f2ba4d0c424b104776d_Out_1_Vector4.xyz);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
            output.TangentSpaceNormal = float3(0.0f, 0.0f, 1.0f);
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/DepthNormalsOnlyPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Meta"
            Tags
            {
                "LightMode" = "Meta"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        #pragma shader_feature _ EDITOR_VISUALIZATION
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define ATTRIBUTES_NEED_TEXCOORD1
        #define ATTRIBUTES_NEED_TEXCOORD2
        #define ATTRIBUTES_NEED_INSTANCEID
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define VARYINGS_NEED_TEXCOORD1
        #define VARYINGS_NEED_TEXCOORD2
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_META
        #define _FOG_FRAGMENT 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/MetaInput.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
             float4 uv1 : TEXCOORD1;
             float4 uv2 : TEXCOORD2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
             float4 texCoord1;
             float4 texCoord2;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float4 texCoord1 : INTERP1;
             float4 texCoord2 : INTERP2;
             float3 positionWS : INTERP3;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.texCoord1.xyzw = input.texCoord1;
            output.texCoord2.xyzw = input.texCoord2;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.texCoord1 = input.texCoord1.xyzw;
            output.texCoord2 = input.texCoord2.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float3 Emission;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4 = _Water_Color;
            float4 _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4 = _Foam_Color;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float4 _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4;
            Unity_Lerp_float4(_Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4, _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4, (_Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float.xxxx), _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.BaseColor = (_Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4.xyz);
            surface.Emission = float3(0, 0, 0);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/LightingMetaPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "SceneSelectionPass"
            Tags
            {
                "LightMode" = "SceneSelectionPass"
            }
        
        // Render State
        Cull Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENESELECTIONPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "ScenePickingPass"
            Tags
            {
                "LightMode" = "Picking"
            }
        
        // Render State
        Cull Back
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_DEPTHONLY
        #define SCENEPICKINGPASS 1
        #define ALPHA_CLIP_THRESHOLD 1
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DOTS.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4 = _Water_Color;
            float4 _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4 = _Foam_Color;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float4 _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4;
            Unity_Lerp_float4(_Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4, _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4, (_Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float.xxxx), _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.BaseColor = (_Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4.xyz);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/SelectionPickingPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
        Pass
        {
            Name "Universal 2D"
            Tags
            {
                "LightMode" = "Universal2D"
            }
        
        // Render State
        Cull Back
        Blend SrcAlpha OneMinusSrcAlpha, One OneMinusSrcAlpha
        ZTest LEqual
        ZWrite Off
        
        // Debug
        // <None>
        
        // --------------------------------------------------
        // Pass
        
        HLSLPROGRAM
        
        // Pragmas
        #pragma target 2.0
        #pragma vertex vert
        #pragma fragment frag
        
        // Keywords
        // PassKeywords: <None>
        // GraphKeywords: <None>
        
        // Defines
        
        #define _NORMALMAP 1
        #define _NORMAL_DROPOFF_TS 1
        #define ATTRIBUTES_NEED_NORMAL
        #define ATTRIBUTES_NEED_TANGENT
        #define ATTRIBUTES_NEED_TEXCOORD0
        #define GRAPH_VERTEX_USES_TIME_PARAMETERS_INPUT
        #define FEATURES_GRAPH_VERTEX_NORMAL_OUTPUT
        #define FEATURES_GRAPH_VERTEX_TANGENT_OUTPUT
        #define VARYINGS_NEED_POSITION_WS
        #define VARYINGS_NEED_TEXCOORD0
        #define FEATURES_GRAPH_VERTEX
        /* WARNING: $splice Could not find named fragment 'PassInstancing' */
        #define SHADERPASS SHADERPASS_2D
        #define REQUIRE_DEPTH_TEXTURE
        
        
        // custom interpolator pre-include
        /* WARNING: $splice Could not find named fragment 'sgci_CustomInterpolatorPreInclude' */
        
        // Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Color.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Texture.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
        #include_with_pragmas "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRenderingKeywords.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/FoveatedRendering.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Input.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/TextureStack.hlsl"
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/DebugMipmapStreamingMacros.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/ShaderGraphFunctions.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/ShaderPass.hlsl"
        
        // --------------------------------------------------
        // Structs and Packing
        
        // custom interpolators pre packing
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPrePacking' */
        
        struct Attributes
        {
             float3 positionOS : POSITION;
             float3 normalOS : NORMAL;
             float4 tangentOS : TANGENT;
             float4 uv0 : TEXCOORD0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(ATTRIBUTES_NEED_INSTANCEID)
             uint instanceID : INSTANCEID_SEMANTIC;
            #endif
        };
        struct Varyings
        {
             float4 positionCS : SV_POSITION;
             float3 positionWS;
             float4 texCoord0;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        struct SurfaceDescriptionInputs
        {
             float3 WorldSpacePosition;
             float4 ScreenPosition;
             float2 NDCPosition;
             float2 PixelPosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct VertexDescriptionInputs
        {
             float3 ObjectSpaceNormal;
             float3 ObjectSpaceTangent;
             float3 ObjectSpacePosition;
             float4 uv0;
             float3 TimeParameters;
        };
        struct PackedVaryings
        {
             float4 positionCS : SV_POSITION;
             float4 texCoord0 : INTERP0;
             float3 positionWS : INTERP1;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
             uint instanceID : CUSTOM_INSTANCE_ID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
             uint stereoTargetEyeIndexAsBlendIdx0 : BLENDINDICES0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
             uint stereoTargetEyeIndexAsRTArrayIdx : SV_RenderTargetArrayIndex;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
             FRONT_FACE_TYPE cullFace : FRONT_FACE_SEMANTIC;
            #endif
        };
        
        PackedVaryings PackVaryings (Varyings input)
        {
            PackedVaryings output;
            ZERO_INITIALIZE(PackedVaryings, output);
            output.positionCS = input.positionCS;
            output.texCoord0.xyzw = input.texCoord0;
            output.positionWS.xyz = input.positionWS;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        Varyings UnpackVaryings (PackedVaryings input)
        {
            Varyings output;
            output.positionCS = input.positionCS;
            output.texCoord0 = input.texCoord0.xyzw;
            output.positionWS = input.positionWS.xyz;
            #if UNITY_ANY_INSTANCING_ENABLED || defined(VARYINGS_NEED_INSTANCEID)
            output.instanceID = input.instanceID;
            #endif
            #if (defined(UNITY_STEREO_MULTIVIEW_ENABLED)) || (defined(UNITY_STEREO_INSTANCING_ENABLED) && (defined(SHADER_API_GLES3) || defined(SHADER_API_GLCORE)))
            output.stereoTargetEyeIndexAsBlendIdx0 = input.stereoTargetEyeIndexAsBlendIdx0;
            #endif
            #if (defined(UNITY_STEREO_INSTANCING_ENABLED))
            output.stereoTargetEyeIndexAsRTArrayIdx = input.stereoTargetEyeIndexAsRTArrayIdx;
            #endif
            #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
            output.cullFace = input.cullFace;
            #endif
            return output;
        }
        
        
        // --------------------------------------------------
        // Graph
        
        // Graph Properties
        CBUFFER_START(UnityPerMaterial)
        float4 _SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D_TexelSize;
        float4 _SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D_TexelSize;
        float _UVScale;
        float _Noise_Speed;
        float _First_Noise_Size;
        float _Second_Noise_Size;
        float _Foam_Distortion_Intensity;
        float4 _Water_Color;
        float4 _Foam_Color;
        float _Water_Opacity;
        float _Foam_Size;
        float _Displacment_Intensity;
        float _Normal_Scale;
        float _Normal_Speed;
        float _Shore_Foam_Distance;
        UNITY_TEXTURE_STREAMING_DEBUG_VARS;
        CBUFFER_END
        
        
        // Object and Global properties
        SAMPLER(SamplerState_Linear_Repeat);
        TEXTURE2D(_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_27fa16c9565e4520be268a346658409e_Texture_1_Texture2D);
        TEXTURE2D(_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        SAMPLER(sampler_SampleTexture2D_c9d9162e90f24baf9d806f6d8951c31b_Texture_1_Texture2D);
        
        // Graph Includes
        #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Hashes.hlsl"
        
        // -- Property used by ScenePickingPass
        #ifdef SCENEPICKINGPASS
        float4 _SelectionID;
        #endif
        
        // -- Properties used by SceneSelectionPass
        #ifdef SCENESELECTIONPASS
        int _ObjectId;
        int _PassValue;
        #endif
        
        // Graph Functions
        
        void Unity_Multiply_float_float(float A, float B, out float Out)
        {
            Out = A * B;
        }
        
        void Unity_Add_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A + B;
        }
        
        float Unity_SimpleNoise_ValueNoise_Deterministic_float (float2 uv)
        {
            float2 i = floor(uv);
            float2 f = frac(uv);
            f = f * f * (3.0 - 2.0 * f);
            uv = abs(frac(uv) - 0.5);
            float2 c0 = i + float2(0.0, 0.0);
            float2 c1 = i + float2(1.0, 0.0);
            float2 c2 = i + float2(0.0, 1.0);
            float2 c3 = i + float2(1.0, 1.0);
            float r0; Hash_Tchou_2_1_float(c0, r0);
            float r1; Hash_Tchou_2_1_float(c1, r1);
            float r2; Hash_Tchou_2_1_float(c2, r2);
            float r3; Hash_Tchou_2_1_float(c3, r3);
            float bottomOfGrid = lerp(r0, r1, f.x);
            float topOfGrid = lerp(r2, r3, f.x);
            float t = lerp(bottomOfGrid, topOfGrid, f.y);
            return t;
        }
        
        void Unity_SimpleNoise_Deterministic_float(float2 UV, float Scale, out float Out)
        {
            float freq, amp;
            Out = 0.0f;
            freq = pow(2.0, float(0));
            amp = pow(0.5, float(3-0));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(1));
            amp = pow(0.5, float(3-1));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
            freq = pow(2.0, float(2));
            amp = pow(0.5, float(3-2));
            Out += Unity_SimpleNoise_ValueNoise_Deterministic_float(float2(UV.xy*(Scale/freq)))*amp;
        }
        
        void Unity_Remap_float2(float2 In, float2 InMinMax, float2 OutMinMax, out float2 Out)
        {
            Out = OutMinMax.x + (In - InMinMax.x) * (OutMinMax.y - OutMinMax.x) / (InMinMax.y - InMinMax.x);
        }
        
        void Unity_DotProduct_float2(float2 A, float2 B, out float Out)
        {
            Out = dot(A, B);
        }
        
        void Unity_Add_float3(float3 A, float3 B, out float3 Out)
        {
            Out = A + B;
        }
        
        void Unity_SceneDepth_Eye_float(float4 UV, out float Out)
        {
            if (unity_OrthoParams.w == 1.0)
            {
                Out = LinearEyeDepth(ComputeWorldSpacePosition(UV.xy, SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), UNITY_MATRIX_I_VP), UNITY_MATRIX_V);
            }
            else
            {
                Out = LinearEyeDepth(SHADERGRAPH_SAMPLE_SCENE_DEPTH(UV.xy), _ZBufferParams);
            }
        }
        
        void Unity_Subtract_float(float A, float B, out float Out)
        {
            Out = A - B;
        }
        
        void Unity_Divide_float(float A, float B, out float Out)
        {
            Out = A / B;
        }
        
        void Unity_Saturate_float(float In, out float Out)
        {
            Out = saturate(In);
        }
        
        void Unity_OneMinus_float(float In, out float Out)
        {
            Out = 1 - In;
        }
        
        void Unity_Step_float(float Edge, float In, out float Out)
        {
            Out = step(Edge, In);
        }
        
        void Unity_Multiply_float4_float4(float4 A, float4 B, out float4 Out)
        {
            Out = A * B;
        }
        
        void Unity_Multiply_float2_float2(float2 A, float2 B, out float2 Out)
        {
            Out = A * B;
        }
        
        // unity-custom-func-begin
        void VoronoiDistance_float(float2 uv, float phase, out float res){
            float2 n = floor(uv);
            
                float2 f = frac(uv);
            
                float2 mg, mr;
            
                float md = 8.0;
            
                        
            
                for (int j= -1; j <= 1; j++)
            
                {
            
                    for (int i= -1; i <= 1; i++)
            
                    {
            
                        float2 g = float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        float d = dot(r,r);
            
                        
            
                        if( d<md )
            
                        {
            
                            md = d;
            
                            mr = r;
            
                            mg = g;
            
                        }
            
                    }
            
                }
            
                        
            
                md = 8.0;
            
                        
            
                for (int j= -2; j <= 2; j++)
            
                {
            
                    for (int i= -2; i <= 2; i++)
            
                    {
            
                        float2 g = mg + float2(i,j);
            
                        float2x2 m = float2x2(15.27, 47.63, 99.41, 89.98);
            
                        float2 uvr =frac(sin(mul(g+n, m)) * 46839.32);
            
                        float2 o = float2(sin(uvr.y*+phase)*0.5+0.5, cos(uvr.x*phase)*0.5+0.5);
            
                        float2 r = g + o - f;
            
                        
            
                        if ( dot(mr-r,mr-r)>0.0001 )
            
                        {
            
                            md = min(md, dot( 0.5*(mr+r), normalize(r-mr) ));
            
                        }
            
                    }
            
                }
            
                        
            
                res = float3(md, mr.x, mr.y);
        }
        // unity-custom-func-end
        
        void Unity_Smoothstep_float(float Edge1, float Edge2, float In, out float Out)
        {
            Out = smoothstep(Edge1, Edge2, In);
        }
        
        void Unity_Maximum_float(float A, float B, out float Out)
        {
            Out = max(A, B);
        }
        
        void Unity_Lerp_float4(float4 A, float4 B, float4 T, out float4 Out)
        {
            Out = lerp(A, B, T);
        }
        
        void Unity_Lerp_float(float A, float B, float T, out float Out)
        {
            Out = lerp(A, B, T);
        }
        
        // Custom interpolators pre vertex
        /* WARNING: $splice Could not find named fragment 'CustomInterpolatorPreVertex' */
        
        // Graph Vertex
        struct VertexDescription
        {
            float3 Position;
            float3 Normal;
            float3 Tangent;
        };
        
        VertexDescription VertexDescriptionFunction(VertexDescriptionInputs IN)
        {
            VertexDescription description = (VertexDescription)0;
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float;
            Unity_DotProduct_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, float2(1, 1), _DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float);
            float _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float = _Displacment_Intensity;
            float _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float;
            Unity_Multiply_float_float(_DotProduct_4f20802cb69f40ed9c6fbbbcbc9c39e0_Out_2_Float, _Property_74473b00a0194504b076a96b20c5ff57_Out_0_Float, _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float);
            float3 _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3 = float3(float(0), _Multiply_856246328359408380a9cf4ae3baf5b4_Out_2_Float, float(0));
            float3 _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            Unity_Add_float3(IN.ObjectSpacePosition, _Vector3_2ea1e206e7ca41f385db16396bc3009d_Out_0_Vector3, _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3);
            description.Position = _Add_29384e137ac84616ad382d86e761997e_Out_2_Vector3;
            description.Normal = IN.ObjectSpaceNormal;
            description.Tangent = IN.ObjectSpaceTangent;
            return description;
        }
        
        // Custom interpolators, pre surface
        #ifdef FEATURES_GRAPH_VERTEX
        Varyings CustomInterpolatorPassThroughFunc(inout Varyings output, VertexDescription input)
        {
        return output;
        }
        #define CUSTOMINTERPOLATOR_VARYPASSTHROUGH_FUNC
        #endif
        
        // Graph Pixel
        struct SurfaceDescription
        {
            float3 BaseColor;
            float Alpha;
        };
        
        SurfaceDescription SurfaceDescriptionFunction(SurfaceDescriptionInputs IN)
        {
            SurfaceDescription surface = (SurfaceDescription)0;
            float4 _Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4 = _Water_Color;
            float4 _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4 = _Foam_Color;
            float _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float;
            Unity_SceneDepth_Eye_float(float4(IN.NDCPosition.xy, 0, 0), _SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float);
            float4 _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4 = IN.ScreenPosition;
            float _Split_052e291dbcc84551a198a1398c62e0e8_R_1_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[0];
            float _Split_052e291dbcc84551a198a1398c62e0e8_G_2_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[1];
            float _Split_052e291dbcc84551a198a1398c62e0e8_B_3_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[2];
            float _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float = _ScreenPosition_d2534953c7b7421f9e870218a62bf464_Out_0_Vector4[3];
            float _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float;
            Unity_Subtract_float(_SceneDepth_34315820498e45db8d2c27523a1ae0e3_Out_1_Float, _Split_052e291dbcc84551a198a1398c62e0e8_A_4_Float, _Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float);
            float _Property_608272d0e610494db715457bf0c4a188_Out_0_Float = _Shore_Foam_Distance;
            float _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float;
            Unity_Divide_float(_Subtract_6a20e9516e714cc4abe091e7802d8eef_Out_2_Float, _Property_608272d0e610494db715457bf0c4a188_Out_0_Float, _Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float);
            float _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float;
            Unity_Saturate_float(_Divide_0526f96bff654c6fae9def49c4d9c349_Out_2_Float, _Saturate_48d1132618924240878947ad7181ae70_Out_1_Float);
            float _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float;
            Unity_OneMinus_float(_Saturate_48d1132618924240878947ad7181ae70_Out_1_Float, _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float);
            float _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float;
            Unity_Step_float(float(0.1), _OneMinus_c10a27839b874a0bbee87c1f11c217ee_Out_1_Float, _Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float);
            float _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float = _Foam_Size;
            float4 _UV_a070f97723194002b94330f1341133e6_Out_0_Vector4 = IN.uv0;
            float _Property_839f9243c47f481db31f7514f8cee501_Out_0_Float = _UVScale;
            float4 _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4;
            Unity_Multiply_float4_float4(_UV_a070f97723194002b94330f1341133e6_Out_0_Vector4, (_Property_839f9243c47f481db31f7514f8cee501_Out_0_Float.xxxx), _Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4);
            float _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float = _Noise_Speed;
            float _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float;
            Unity_Multiply_float_float(IN.TimeParameters.x, _Property_8140ce59a20c4325bec7dd395cbdb519_Out_0_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, float(0));
            float4 _UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4 = IN.uv0;
            float2 _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2;
            Unity_Add_float2(_Vector2_5e081da7103e451badaa66b3fa06e2c2_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2);
            float _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float = _First_Noise_Size;
            float _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_3b36f9867035468ea17482189af374fa_Out_2_Vector2, _Property_cf58075175bb4d6f8561ffc397ac7316_Out_0_Float, _SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float);
            float2 _Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2 = float2(_Multiply_b967711082d94218976eecce7463e35a_Out_2_Float, _Multiply_b967711082d94218976eecce7463e35a_Out_2_Float);
            float2 _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2;
            Unity_Add_float2(_Vector2_3af26ff15e6148a3803fcaff9abf77bc_Out_0_Vector2, (_UV_94d341d0db784c588dcc7f8b573db789_Out_0_Vector4.xy), _Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2);
            float _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float = _Second_Noise_Size;
            float _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float;
            Unity_SimpleNoise_Deterministic_float(_Add_10bbbf8830d1409f81f64a8380cfb4d7_Out_2_Vector2, _Property_76c4d2bb757043109e0401f3f1e456f4_Out_0_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2 = float2(_SimpleNoise_cffaaed3cfde4849b282d601c0f072aa_Out_2_Float, _SimpleNoise_cad005a9d7864097975800c5c51d97c8_Out_2_Float);
            float2 _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2;
            Unity_Remap_float2(_Vector2_1b89a5c695a645cdb15a1e003e2ea523_Out_0_Vector2, float2 (0, 1), float2 (-1, 1), _Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2);
            float _Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float = _Foam_Distortion_Intensity;
            float2 _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2;
            Unity_Multiply_float2_float2(_Remap_e170da85e70d4cf8ab47a29aa251dfad_Out_3_Vector2, (_Property_213e9061d2dc47c8b0f2f93b72736fad_Out_0_Float.xx), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2);
            float2 _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2;
            Unity_Add_float2((_Multiply_6672cf6ff4e94c548f3d7b83658afb46_Out_2_Vector4.xy), _Multiply_75a1fbf0343841eb85c6a3a618b4e3fe_Out_2_Vector2, _Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2);
            float _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float;
            VoronoiDistance_float(_Add_aa9e945ce441483fb56132cc8f30ad9f_Out_2_Vector2, IN.TimeParameters.x, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float);
            float _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float;
            Unity_Smoothstep_float(float(0), _Property_dea0b25650204420bbd2f0bf242e9456_Out_0_Float, _VoronoiDistanceCustomFunction_997213ff4087427aaf900ec5e8f78880_res_0_Float, _Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float);
            float _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float;
            Unity_OneMinus_float(_Smoothstep_8a912715f9324be3a1437c7e65d1c999_Out_3_Float, _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float);
            float _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float;
            Unity_Step_float(float(0.5), _OneMinus_2e6c01664eef4d7b9e636a56b8421c17_Out_1_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float);
            float _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float;
            Unity_Maximum_float(_Step_a8bfb26fb2774a70aedd6b96be023b5a_Out_2_Float, _Step_b6fb084c39974b2ab4209520fae91b15_Out_2_Float, _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float);
            float4 _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4;
            Unity_Lerp_float4(_Property_4fd8704b78dd4ed9a3f136de3045b89a_Out_0_Vector4, _Property_512e6f7273bd4fe1a122d492d9831039_Out_0_Vector4, (_Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float.xxxx), _Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4);
            float _Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float = _Water_Opacity;
            float _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            Unity_Lerp_float(_Property_ec8f096bae5640eabd5b9022fd66fa39_Out_0_Float, float(1), _Maximum_df6a1b22d2564e2988106b8176a554f8_Out_2_Float, _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float);
            surface.BaseColor = (_Lerp_6a77961b82704f4cbc3ceab50cec4e4d_Out_3_Vector4.xyz);
            surface.Alpha = _Lerp_67f2174f87bf46d7a865160d9bb41c33_Out_3_Float;
            return surface;
        }
        
        // --------------------------------------------------
        // Build Graph Inputs
        #ifdef HAVE_VFX_MODIFICATION
        #define VFX_SRP_ATTRIBUTES Attributes
        #define VFX_SRP_VARYINGS Varyings
        #define VFX_SRP_SURFACE_INPUTS SurfaceDescriptionInputs
        #endif
        VertexDescriptionInputs BuildVertexDescriptionInputs(Attributes input)
        {
            VertexDescriptionInputs output;
            ZERO_INITIALIZE(VertexDescriptionInputs, output);
        
            output.ObjectSpaceNormal =                          input.normalOS;
            output.ObjectSpaceTangent =                         input.tangentOS.xyz;
            output.ObjectSpacePosition =                        input.positionOS;
            output.uv0 =                                        input.uv0;
            output.TimeParameters =                             _TimeParameters.xyz;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
        
            return output;
        }
        SurfaceDescriptionInputs BuildSurfaceDescriptionInputs(Varyings input)
        {
            SurfaceDescriptionInputs output;
            ZERO_INITIALIZE(SurfaceDescriptionInputs, output);
        
        #ifdef HAVE_VFX_MODIFICATION
        #if VFX_USE_GRAPH_VALUES
            uint instanceActiveIndex = asuint(UNITY_ACCESS_INSTANCED_PROP(PerInstance, _InstanceActiveIndex));
            /* WARNING: $splice Could not find named fragment 'VFXLoadGraphValues' */
        #endif
            /* WARNING: $splice Could not find named fragment 'VFXSetFragInputs' */
        
        #endif
        
            
        
        
        
        
        
            output.WorldSpacePosition = input.positionWS;
            output.ScreenPosition = ComputeScreenPos(TransformWorldToHClip(input.positionWS), _ProjectionParams.x);
        
            #if UNITY_UV_STARTS_AT_TOP
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x < 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #else
            output.PixelPosition = float2(input.positionCS.x, (_ProjectionParams.x > 0) ? (_ScaledScreenParams.y - input.positionCS.y) : input.positionCS.y);
            #endif
        
            output.NDCPosition = output.PixelPosition.xy / _ScaledScreenParams.xy;
            output.NDCPosition.y = 1.0f - output.NDCPosition.y;
        
            output.uv0 = input.texCoord0;
        #if UNITY_ANY_INSTANCING_ENABLED
        #else // TODO: XR support for procedural instancing because in this case UNITY_ANY_INSTANCING_ENABLED is not defined and instanceID is incorrect.
        #endif
            output.TimeParameters = _TimeParameters.xyz; // This is mainly for LW as HD overwrite this value
        #if defined(SHADER_STAGE_FRAGMENT) && defined(VARYINGS_NEED_CULLFACE)
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN output.FaceSign =                    IS_FRONT_VFACE(input.cullFace, true, false);
        #else
        #define BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        #endif
        #undef BUILD_SURFACE_DESCRIPTION_INPUTS_OUTPUT_FACESIGN
        
                return output;
        }
        
        // --------------------------------------------------
        // Main
        
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/Varyings.hlsl"
        #include "Packages/com.unity.render-pipelines.universal/Editor/ShaderGraph/Includes/PBR2DPass.hlsl"
        
        // --------------------------------------------------
        // Visual Effect Vertex Invocations
        #ifdef HAVE_VFX_MODIFICATION
        #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/VisualEffectVertex.hlsl"
        #endif
        
        ENDHLSL
        }
    }
    CustomEditor "UnityEditor.ShaderGraph.GenericShaderGraphMaterialGUI"
    CustomEditorForRenderPipeline "UnityEditor.ShaderGraphLitGUI" "UnityEngine.Rendering.Universal.UniversalRenderPipelineAsset"
    FallBack "Hidden/Shader Graph/FallbackError"
}