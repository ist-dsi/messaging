<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://www.springframework.org/tags" prefix="spring"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<h2><spring:message code="title.sender"/></h2>
<table class="table table-condensed">
	<tbody>
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.name"/>
			</th>
			<td>
				${sender.fromName}
			</td>
		</tr>
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.address"/>
			</th>
			<td>
				<code>${sender.fromAddress}</code>
			</td>
		</tr>
		<c:if test="${not empty replyTos}">
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.replyTos"/>
			</th>
			<td>
				<div style="overflow-y:auto; max-height:85px; display:block;">
				<c:forEach items="${replyTos}" var="replyTo">
					<code style="display: inline-block; margin: 2px;">${replyTo}</code>
				</c:forEach>
				</div>
			</td>
		</tr>
		</c:if>
		<c:if test="${not empty recipients}">
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.recipients"/>
			</th>
			<td>
				<div style="overflow-y:auto; max-height:85px; display:block;">
				<c:forEach items="${recipients}" var="recipient">
					<code style="display: inline-block; margin: 2px;">${recipient.presentationName}</code>
				</c:forEach>
				</div>
			</td>
		</tr>
		</c:if>
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.policy"/>
			</th>
			<td>
				${sender.policy.toString()}
			</td>
		</tr>
		<tr>
			<th class="col-md-2" scope="row">
				<spring:message code="label.sender.html"/>
			</th>
			<td>
				<c:choose>
					<c:when test="${ sender.htmlSender }">
						<spring:message code="label.yes"/>
					</c:when>
					<c:otherwise>
						<spring:message code="label.no"/>
					</c:otherwise>
				</c:choose>
			</td>
		</tr>
	</tbody>
</table>

<h3><spring:message code="title.messages"/></h3>
<a class="btn btn-primary" href="${pageContext.request.contextPath}/messaging/message?sender=${sender.externalId}">
	<spring:message code="action.message.new"/>
</a>
<c:if test="${not empty messages}">
	<br/>
	<table class="table table-hover table-condensed">
		<thead>
			<tr>
				<th>
					<spring:message code="label.message.created"/>
				</th>
				<th>
					<spring:message code="label.message.subject"/>
				</th>
				<th>
					<spring:message code="label.message.status.sent"/>
				</th>
				<th>
				</th>
			</tr>
		</thead>
		<tbody>
		<c:forEach items="${messages}" var="message">
			<tr onClick="location.href='${pageContext.request.contextPath}/messaging/messages/${message.externalId}'">
				<td class="col-sm-2">${message.created.toString("dd-MM-yyyy HH:mm:ss")}</td>
				<td class="col-sm-6"><c:out value="${message.subject.content}"/></td>
				<td class="col-sm-3">
					<c:choose>
						<c:when test="${not empty message.sent}">
							${message.sent.toString("dd-MM-yyyy HH:mm:ss")}
						</c:when>
						<c:when test="${not empty message.dispatchReport.startedDelivery}">
							<spring:message code="label.message.status.dispatching"/>
							<c:set var="invalid" value="${message.dispatchReport.invalidCount}"/>
							<c:set var="failed" value="${message.dispatchReport.failedCount}"/>
							<c:set var="delivered" value="${message.dispatchReport.deliveredCount}"/>
							<c:set var="total" value="${message.dispatchReport.totalCount}"/>
							<c:set var="pInvalid" value="${100 *message.dispatchReport.invalidCount/total}"/>
							<c:set var="pFailed" value="${100 *message.dispatchReport.failedCount/total}"/>
							<c:set var="pDelivered" value="${100 * message.dispatchReport.deliveredCount/total}"/>
							<div class="progress" style="margin: 0;">
								<div class="progress-bar progress-bar-danger" style="width: ${pFailed}%" data-toggle="tooltip" data-placement="bottom" title="${failed} failed messages">
									<fmt:formatNumber type="number" maxFractionDigits="1" value="${pFailed}"/>%
								</div>
								<div class="progress-bar progress-bar-warning" style="width: ${pInvalid}%" data-toggle="tooltip" data-placement="bottom" title="${invalid} invalid messages">
									<fmt:formatNumber type="number" maxFractionDigits="1" value="${pInvalid}"/>%
								</div>
								<div class="progress-bar progress-bar-success" style="width: ${pDelivered}%" data-toggle="tooltip" data-placement="bottom"  title="${delivered} delivered messages">
									<fmt:formatNumber type="number" maxFractionDigits="1" value="${pDelivered}"/>%
								</div>
							</div>
							<script type="text/javascript">
								$(".progress-bar").tooltip();
							</script>
						</c:when>
						<c:otherwise>
							<spring:message code="label.message.status.queued"/>
						</c:otherwise>
					</c:choose>
				</td>
				<td class="col-sm-1">
					<a class="btn btn-xs btn-default pull-right" href="${pageContext.request.contextPath}/messaging/messages/${message.externalId}">
						<spring:message code="action.view.details"/>
					</a>
				</td>
			</tr>
		</c:forEach>
		</tbody>
			<tfoot>
				<tr>
					<td colspan="4">
						<%@ include file="pagination.jsp" %>
					</td>
				</tr>
			</tfoot>
	</table>
</c:if>
