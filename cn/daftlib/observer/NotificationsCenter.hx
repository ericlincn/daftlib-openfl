package cn.daftlib.observer;

/**
 * ...
 * @author eric.lin
 */
@:final class NotificationsCenter
{
	private static var __observerMap:Map<String, Array<IObserver>> = new Map<String, Array<IObserver>>();

	public static function register(notificationName:String, observer:IObserver):Void
	{
		var observersArr:Array<IObserver> = __observerMap[notificationName];
		if(observersArr != null)
		{
			var i:Int = observersArr.length;
			while((i--)>0)
			{
				if(observersArr[i] == observer)
					return;
			}

			observersArr.push(observer);
		}
		else
			__observerMap[notificationName] = [observer];
	}
	public static function sendNotification(notificationName:String, data:Dynamic):Void
	{
		var observersArr:Array<IObserver> = __observerMap[notificationName];
		if(observersArr == null)
			return;

		var i:Int = 0;
		while(i < observersArr.length)
		{
			var observer:IObserver = observersArr[i];
			var callback:INotification->Void  = observer.handlerNotification;
			var notification:Notification = new Notification(notificationName, data);
			//callback.apply(null, [notification]);
			Reflect.callMethod(null, callback, [notification]);

			i++;
		}
	}
	public static function unregisterForNotification(notificationName:String):Void
	{
		__observerMap.remove(notificationName);
	}
	public static function unregisterForObserver(observer:IObserver):Void
	{
		for(key in __observerMap.keys())
		{
			var observersArr:Array<IObserver> = __observerMap[key];

			var i:Int = observersArr.length;
			while((i--)>0)
			{
				if(observersArr[i] == observer)
					observersArr.splice(i, 1);
			}

			if(observersArr.length == 0)
				__observerMap.remove(key);
		}
	}
	public static function unregister(notificationName:String, observer:IObserver):Void
	{
		var observersArr:Array<IObserver> = __observerMap[notificationName];
		if(observersArr == null)
			return;

		var i:Int = observersArr.length;
		while((i--)>0)
		{
			if(observersArr[i] == observer)
				observersArr.splice(i, 1);
		}

		if(observersArr.length == 0)
			__observerMap.remove(notificationName);
	}
}