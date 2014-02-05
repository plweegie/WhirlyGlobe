package com.mousebirdconsulting.maply;

/**
 * The renderer encapsulates the OpenGL ES specific rendering.
 * This is opaque to the toolkit user.
 * 
 * @author sjg
 *
 */
class MaplyRenderer
{
	public Point2d frameSize = new Point2d();
	
	MaplyRenderer()
	{
		initialise();		
	}

	public void finalize()
	{
		dispose();
	}

	public boolean setup()
	{
//		return resize();
		return true;
	}
	
	public boolean surfaceChanged(int width,int height)
	{
		frameSize.setValue(width, height);
		return resize(width,height);
	}
	
	public void doRender()
	{
		render();
	}

	public native void setScene(MapScene scene);
	public native void setView(MapView view);
	public native void setClearColor(float r,float g,float b,float a);
	protected native boolean teardown();
	protected native boolean resize(int width,int height);
	protected native void render();

	static
	{
		nativeInit();
	}
	private static native void nativeInit();
	native void initialise();
	native void dispose();
	private long nativeHandle;
	
	static
	{
//		System.loadLibrary("Maply");
	}
}
