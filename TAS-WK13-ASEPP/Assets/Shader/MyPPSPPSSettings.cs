// Amplify Shader Editor - Visual Shader Editing Tool
// Copyright (c) Amplify Creations, Lda <info@amplify.pt>
#if UNITY_POST_PROCESSING_STACK_V2
using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess( typeof( MyPPSPPSRenderer ), PostProcessEvent.AfterStack, "MyPPS", true )]
public sealed class MyPPSPPSSettings : PostProcessEffectSettings
{
	[Tooltip( "Screen" )]
	public TextureParameter _MainTex = new TextureParameter {  };
	[Tooltip( "Distance" )]
	public FloatParameter _Distance = new FloatParameter { value = 10f };
	[Tooltip( "FogColor" )]
	public ColorParameter _FogColor = new ColorParameter { value = new Color(0.8490566f,0.5946379f,0.4445532f,0f) };
}

public sealed class MyPPSPPSRenderer : PostProcessEffectRenderer<MyPPSPPSSettings>
{
	public override void Render( PostProcessRenderContext context )
	{
		var sheet = context.propertySheets.Get( Shader.Find( "MyPPS" ) );
		if(settings._MainTex.value != null) sheet.properties.SetTexture( "_MainTex", settings._MainTex );
		sheet.properties.SetFloat( "_Distance", settings._Distance );
		sheet.properties.SetColor( "_FogColor", settings._FogColor );
		context.command.BlitFullscreenTriangle( context.source, context.destination, sheet, 0 );
	}
}
#endif
