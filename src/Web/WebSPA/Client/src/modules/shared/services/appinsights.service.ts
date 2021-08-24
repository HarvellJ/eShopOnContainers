import { Injectable } from '@angular/core';
import * as applicationinsightsWeb from '@microsoft/applicationinsights-web';
import { StorageService } from './storage.service';

@Injectable({ providedIn: 'root' })
export class ApplicationInsightsService {
    private appInsights: applicationinsightsWeb.ApplicationInsights;

    constructor() {
       
    }
    load() {
        var aiKey = '05bbe9a1-9d8e-44d2-83a6-e70e19ad13c7';
        this.appInsights = new applicationinsightsWeb.ApplicationInsights({
            config: {
                instrumentationKey: aiKey,
                enableAutoRouteTracking: true,
                autoTrackPageVisitTime: true
            }
        });

        this.appInsights.loadAppInsights();
        this.loadCustomTelemetryProperties();
    }
    logTrace(message: string, properties?: { [key: string]: any }) {
        this.appInsights.trackTrace({ message: message }, properties);
    }
    logMetric(name: string, average: number, properties?: { [key: string]: any }) {
        this.appInsights.trackMetric({ name: name, average: average }, properties);
    }
    setUserId(userId: string) {
        this.appInsights.setAuthenticatedUserContext(userId);
    }
    clearUserId() {
        this.appInsights.clearAuthenticatedUserContext();
    }
    logPageView(name?: string, uri?: string, workstation?: string) {
        let MyPageView: applicationinsightsWeb.IPageViewTelemetry = { name: name, uri: uri, properties: { ['workstation']: workstation } }
        this.appInsights.trackPageView(MyPageView);
    }
    logException(error: Error) {
        let exception: applicationinsightsWeb.IExceptionTelemetry = {
            exception: error
        };
        this.appInsights.trackException(exception);
    }

    private loadCustomTelemetryProperties() {
        this.appInsights.addTelemetryInitializer(envelope => {
            var item = envelope.baseData;
            item.properties = item.properties || {};
            item.properties["ApplicationPlatform"] = "ApplicationPlatform";
            item.properties["ApplicationName"] = "ApplicationName";
            if (item.url === 'url you dont want to track') { return false; }
        }
        );
    }
}
