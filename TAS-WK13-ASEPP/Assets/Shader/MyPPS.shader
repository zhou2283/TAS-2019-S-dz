// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "MyPPS"
{
	Properties
	{
		_MainTex ( "Screen", 2D ) = "black" {}
		_Distance("Distance", Range( 0 , 100)) = 10
		_FogColor("FogColor", Color) = (0.8490566,0.5946379,0.4445532,0)
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
	}

	SubShader
	{
		
		
		ZTest Always
		Cull Off
		ZWrite Off

		
		Pass
		{ 
			CGPROGRAM 

			#pragma vertex vert_img_custom 
			#pragma fragment frag
			#pragma target 3.0
			#include "UnityCG.cginc"
			

			struct appdata_img_custom
			{
				float4 vertex : POSITION;
				half2 texcoord : TEXCOORD0;
				
			};

			struct v2f_img_custom
			{
				float4 pos : SV_POSITION;
				half2 uv   : TEXCOORD0;
				half2 stereoUV : TEXCOORD2;
		#if UNITY_UV_STARTS_AT_TOP
				half4 uv2 : TEXCOORD1;
				half4 stereoUV2 : TEXCOORD3;
		#endif
				float4 ase_texcoord4 : TEXCOORD4;
			};

			uniform sampler2D _MainTex;
			uniform half4 _MainTex_TexelSize;
			uniform half4 _MainTex_ST;
			
			UNITY_DECLARE_DEPTH_TEXTURE( _CameraDepthTexture );
			uniform float4 _CameraDepthTexture_TexelSize;
			uniform float _Distance;
			uniform float4 _FogColor;

			v2f_img_custom vert_img_custom ( appdata_img_custom v  )
			{
				v2f_img_custom o;
				float4 ase_clipPos = UnityObjectToClipPos(v.vertex);
				float4 screenPos = ComputeScreenPos(ase_clipPos);
				o.ase_texcoord4 = screenPos;
				
				o.pos = UnityObjectToClipPos ( v.vertex );
				o.uv = float4( v.texcoord.xy, 1, 1 );

				#if UNITY_UV_STARTS_AT_TOP
					o.uv2 = float4( v.texcoord.xy, 1, 1 );
					o.stereoUV2 = UnityStereoScreenSpaceUVAdjust ( o.uv2, _MainTex_ST );

					if ( _MainTex_TexelSize.y < 0.0 )
						o.uv.y = 1.0 - o.uv.y;
				#endif
				o.stereoUV = UnityStereoScreenSpaceUVAdjust ( o.uv, _MainTex_ST );
				return o;
			}

			half4 frag ( v2f_img_custom i ) : SV_Target
			{
				#ifdef UNITY_UV_STARTS_AT_TOP
					half2 uv = i.uv2;
					half2 stereoUV = i.stereoUV2;
				#else
					half2 uv = i.uv;
					half2 stereoUV = i.stereoUV;
				#endif	
				
				half4 finalColor;

				// ase common template code
				float2 uv_MainTex = i.uv.xy * _MainTex_ST.xy + _MainTex_ST.zw;
				float4 screenPos = i.ase_texcoord4;
				float4 ase_screenPosNorm = screenPos / screenPos.w;
				ase_screenPosNorm.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? ase_screenPosNorm.z : ase_screenPosNorm.z * 0.5 + 0.5;
				float eyeDepth21 = LinearEyeDepth(UNITY_SAMPLE_DEPTH(tex2Dproj(_CameraDepthTexture,UNITY_PROJ_COORD( ase_screenPosNorm ))));
				float clampResult46 = clamp( ( eyeDepth21 / _Distance ) , 0.0 , 1.0 );
				float clampResult68 = clamp( ( pow( abs( ( ase_screenPosNorm.x - 0.5 ) ) , 2.0 ) + pow( abs( ( ase_screenPosNorm.y - 0.5 ) ) , 2.0 ) ) , 0.0 , 1.0 );
				

				finalColor = ( ( ( tex2D( _MainTex, uv_MainTex ) * ( 1.0 - clampResult46 ) ) + ( clampResult46 * _FogColor ) ) * ( 1.0 - clampResult68 ) );

				return finalColor;
			} 
			ENDCG 
		}
	}
	CustomEditor "ASEMaterialInspector"
	
	
}
/*ASEBEGIN
Version=16700
256;136.8;1523;790;2428.708;734.7844;3.243273;True;True
Node;AmplifyShaderEditor.CommentaryNode;51;-1034.527,2.666443;Float;False;1650.967;893.8132;Comment;12;48;49;41;2;44;47;46;1;23;24;21;22;;1,1,1,1;0;0
Node;AmplifyShaderEditor.CommentaryNode;69;-630.6733,984.3418;Float;False;1240.329;386.2366;Comment;9;53;64;68;66;62;63;56;55;52;;1,1,1,1;0;0
Node;AmplifyShaderEditor.ScreenPosInputsNode;22;-996.2781,701.5228;Float;False;0;False;0;5;FLOAT4;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SimpleSubtractOpNode;55;-527.6412,1246.86;Float;False;2;0;FLOAT;0;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;24;-791.6887,644.339;Float;False;Property;_Distance;Distance;0;0;Create;True;0;0;False;0;10;9.7;0;100;0;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleSubtractOpNode;52;-502.3101,1028.505;Float;False;2;0;FLOAT;1;False;1;FLOAT;0.5;False;1;FLOAT;0
Node;AmplifyShaderEditor.ScreenDepthNode;21;-695.3373,489.2421;Float;False;0;True;1;0;FLOAT4;0,0,0,0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleDivideOpNode;23;-339.7086,424.0616;Float;False;2;0;FLOAT;0;False;1;FLOAT;10;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;53;-315.8051,1024.95;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.AbsOpNode;56;-348.0248,1268.043;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.TemplateShaderPropertyNode;1;-971.1578,83.14063;Float;False;0;0;_MainTex;Shader;0;5;SAMPLER2D;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.PowerNode;62;-155.245,1018.816;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;46;-143.4912,444.2361;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.PowerNode;63;-205.6335,1265.408;Float;False;2;0;FLOAT;0;False;1;FLOAT;2;False;1;FLOAT;0
Node;AmplifyShaderEditor.SamplerNode;2;-634.7438,68.22212;Float;True;Property;_TextureSample0;Texture Sample 0;0;0;Create;True;0;0;False;0;None;None;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.ColorNode;44;-207.2893,669.9349;Float;False;Property;_FogColor;FogColor;1;0;Create;True;0;0;False;0;0.8490566,0.5946379,0.4445532,0;0.3478297,0.3409131,0.4433962,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.OneMinusNode;47;32.47063,329.861;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;66;51.05531,1166.978;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ClampOpNode;68;236.0005,1141.896;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;41;199.6344,87.03342;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;49;192.5957,653.6307;Float;False;2;2;0;FLOAT;0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.OneMinusNode;64;437.5834,1143.315;Float;False;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleAddOpNode;48;470.6157,227.803;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;65;760.6526,940.828;Float;False;2;2;0;COLOR;0,0,0,0;False;1;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.TemplateMultiPassMasterNode;0;948.9456,938.5692;Float;False;True;2;Float;ASEMaterialInspector;0;2;MyPPS;c71b220b631b6344493ea3cf87110c93;True;SubShader 0 Pass 0;0;0;SubShader 0 Pass 0;1;False;False;False;True;2;False;-1;False;False;True;2;False;-1;True;7;False;-1;False;True;0;False;0;False;False;False;False;False;False;False;False;False;False;True;2;0;;0;0;Standard;0;0;1;True;False;1;0;FLOAT4;0,0,0,0;False;0
WireConnection;55;0;22;2
WireConnection;52;0;22;1
WireConnection;21;0;22;0
WireConnection;23;0;21;0
WireConnection;23;1;24;0
WireConnection;53;0;52;0
WireConnection;56;0;55;0
WireConnection;62;0;53;0
WireConnection;46;0;23;0
WireConnection;63;0;56;0
WireConnection;2;0;1;0
WireConnection;47;0;46;0
WireConnection;66;0;62;0
WireConnection;66;1;63;0
WireConnection;68;0;66;0
WireConnection;41;0;2;0
WireConnection;41;1;47;0
WireConnection;49;0;46;0
WireConnection;49;1;44;0
WireConnection;64;0;68;0
WireConnection;48;0;41;0
WireConnection;48;1;49;0
WireConnection;65;0;48;0
WireConnection;65;1;64;0
WireConnection;0;0;65;0
ASEEND*/
//CHKSM=D3AA41CF2AF4CB9E4B0E0986FADD337CCB6393C7