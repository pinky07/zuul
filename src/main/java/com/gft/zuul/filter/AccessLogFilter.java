package com.gft.zuul.filter;

import java.util.Collection;
import java.util.Collections;
import java.util.Enumeration;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;
import java.util.function.Function;
import java.util.stream.Collectors;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Component;

import com.netflix.util.Pair;
import com.netflix.zuul.ZuulFilter;
import com.netflix.zuul.context.RequestContext;

@Component
public class AccessLogFilter extends ZuulFilter {

	private Logger logger = LoggerFactory.getLogger(AccessLogFilter.class);

	@Override
	public String filterType() {
		return "post";
	}

	@Override
	public int filterOrder() {
		return FilterOrder.ACCESS_LOG_FILTER_ORDER;
	}

	@Override
	public boolean shouldFilter() {
		return true;
	}

	@Override
	public Object run() {
		RequestContext ctx = RequestContext.getCurrentContext();
		HttpServletRequest request = ctx.getRequest();
		HttpServletResponse response = ctx.getResponse();
		Map<String, String> zuulRequestHeaders = ctx.getZuulRequestHeaders();
		List<Pair<String, String>> zuulResponseHeaders = ctx.getZuulResponseHeaders();

		logger.trace("HttpServletRequest:");
		logger.trace("\tScheme: " + request.getScheme());
		logger.trace("\tURL: " +
				request.getMethod() + " " +
				request.getLocalName() + ":" +
				request.getLocalPort() +
				request.getRequestURI() +
				(request.getQueryString() != null ? ("?" + request.getQueryString()) : ""));
		logHeaders(request.getHeaderNames(), s -> request.getHeaders(s));

		logger.trace("Zuul Request:");
		zuulRequestHeaders.forEach((k, v) -> logger.trace("\tHeader: " + k + ": " + v));

		logger.trace("HttpServletResponse:");
		logger.trace("\tStatus: " + response.getStatus());
		logHeaders(response.getHeaderNames(), s -> response.getHeaders(s));

		logger.trace("Zuul Response:");
		zuulResponseHeaders.forEach(v -> logger.trace("\tHeader: " + v.first() + ": " + v.second()));

		return null;
	}

	private void logHeaders(Enumeration<String> headerNames,
			Function<String, Enumeration<String>> getHeaderValuesFunction) {
		logHeaders(Collections.list(headerNames), e -> Collections.list(getHeaderValuesFunction.apply(e)));
	}

	private void logHeaders(Collection<String> headerNames,
			Function<String, Collection<String>> getHeaderValuesFunction) {
		headerNames
				.stream()
				.collect(Collectors.toMap(
						Function.identity(),
						headerName -> getHeaderValuesFunction.apply(headerName),
						(c1, c2) -> {
							c1.addAll(c2);
							return c1;
						},
						TreeMap::new))
				.forEach((headerName, headerValues) -> logger
						.trace("\tHeader: " + headerName + " --> " + String.join(" | ", headerValues)));
	}
}
